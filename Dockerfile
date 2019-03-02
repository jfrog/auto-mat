FROM docker.bintray.io/jfrog/openjdk:8u131 AS builder
WORKDIR /opt
RUN apt-get update && apt-get install -y wget unzip default-jdk
RUN wget -O mat.zip http://mirrors.uniri.hr/eclipse//mat/1.8/rcp/MemoryAnalyzer-1.8.0.20180604-linux.gtk.x86_64.zip
RUN unzip mat.zip
RUN rm mat.zip

FROM docker.bintray.io/jfrog/openjdk:8u131
WORKDIR /opt
COPY --from=builder /opt/mat /opt/mat
COPY run.sh ./mat
WORKDIR /data
ENTRYPOINT ["/opt/mat/run.sh"]
CMD []
