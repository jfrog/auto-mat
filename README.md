# What is auto-mat
Automat is a docker container that allows you to analyse a Java heap dump from the commandline without any GUI involved. You can get html reports directly from the commandline.

# How to run?
cd to the location of your heap dump file, then:
```docker run --mount src=$(pwd),target=/data,type=bind -it auto-mat <dump filename> <heap size for mat> <reports>```

dump filename - hprof heap dump

heap size for mat - how much memory to consume for this process

reports - a comma separated list of the following: suspects, overview, top_components. If empty no reports will be generated.

# What problem does it solve?

Analyzing large heap dumps is a long process which needs a lot of computing resources. Eclipse Memory Analyzer Tool (http://www.eclipse.org/mat/downloads.php) is GUI based tool to analyze heap dumps. It takes a lot of time to run an analysis for the first time with MAT and it consumes a lot of , however when running for the second time it is fast, thats because MAT keeps indexes locally on the running machine.

Auto-mat can help with that because it can let you run the analysis on any remote machine that has docker installed. Then you can copy the output to your local machine, run MAT and open the heap dump.
Auto-mat will also generate HTML reports which might save you the effort of running MAT.

### Example:

```docker run -it --mount src=$(pwd),target=/data,type=bind auto-mat heap1.hprof 11g suspects,overview```

# How to build:

```docker build . -t auto-mat:<tag name>```

# How it works?

This is a simple docker wrapper for tools that came from eclipse MAT. Eclipse MAT exposes command line tool to generate indexes and reports.

