FROM ubuntu:18.04 AS builder
WORKDIR /opt
RUN apt-get update && apt-get install -y wget unzip
RUN wget -O mat.zip http://mirrors.uniri.hr/eclipse//mat/1.8/rcp/MemoryAnalyzer-1.8.0.20180604-linux.gtk.x86_64.zip
RUN unzip mat.zip
RUN rm mat.zip

FROM ubuntu:18.04
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;
WORKDIR /opt
COPY --from=builder /opt/mat /opt/mat
COPY run.sh ./mat
WORKDIR /data
ENTRYPOINT ["/opt/mat/run.sh"]
