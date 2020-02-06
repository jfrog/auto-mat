import com.sun.management.HotSpotDiagnosticMXBean;
import org.apache.commons.io.FileUtils;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.zeroturnaround.exec.ProcessExecutor;
import org.zeroturnaround.exec.ProcessResult;

import javax.management.MBeanServer;
import java.io.File;
import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeoutException;

public class LeakyTest {

    private static final String TESTS_OUTPUT = "tests-output";
    private Map<String, Object> m = new HashMap<>();
    private boolean stop = false;

    @BeforeClass
    public static void init() throws IOException {
        FileUtils.deleteDirectory(new File(TESTS_OUTPUT));
    }

    @Test
    public void leakTest() throws IOException, TimeoutException, InterruptedException {
        Thread t = new Thread(() -> {
            int i = 0;
            while (true) {
                i++;
                m.put(String.valueOf(i), new Object());
                if (stop) {
                    return;
                }
            }
        });
        t.start();

        Files.createDirectory(Paths.get(TESTS_OUTPUT));
        dumpHeap("tests-output/dump.hprof", true);
        stop = true;
        final String tagPropVal = System.getProperty("docker.tag");
        String dockerTag = (tagPropVal == null || tagPropVal.isEmpty() || tagPropVal.equals("null")) ? "latest" : tagPropVal;
        System.out.println("Executing docker with dockerTag:" + dockerTag);
        String currentDir = System.getProperty("user.dir");
        ProcessExecutor processConfig = new ProcessExecutor()
                .command("docker", "run", "--mount", "src=" + currentDir +
                        "/tests-output,target=/data,type=bind", "jfrog-docker-reg2.bintray.io/jfrog/auto-mat:" +
                        dockerTag, "dump.hprof", "11g", "suspects,overview")
                .redirectOutput(System.out)
                .redirectError(System.out)
                .destroyOnExit();
        ProcessResult res = processConfig.execute();
        Assert.assertEquals(0, res.getExitValue());
        Assert.assertTrue(Files.exists(Paths.get("tests-output/dump_Leak_Suspects.zip")));
        Assert.assertTrue(Files.exists(Paths.get("tests-output/dump_System_Overview.zip")));
    }

    private static void dumpHeap(String filePath, boolean live) throws IOException {
        MBeanServer server = ManagementFactory.getPlatformMBeanServer();
        HotSpotDiagnosticMXBean mxBean = ManagementFactory.newPlatformMXBeanProxy(
                server, "com.sun.management:type=HotSpotDiagnostic", HotSpotDiagnosticMXBean.class);
        mxBean.dumpHeap(filePath, live);
    }
}
