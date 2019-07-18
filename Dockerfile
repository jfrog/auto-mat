FROM adoptopenjdk/openjdk8:alpine AS builder
WORKDIR /opt
RUN apk update && apk add wget unzip
RUN wget -O mat.zip http://mirrors.uniri.hr/eclipse//mat/1.8/rcp/MemoryAnalyzer-1.8.0.20180604-linux.gtk.x86_64.zip
RUN unzip mat.zip

FROM adoptopenjdk/openjdk8:alpine
RUN apk add --no-cache bash
WORKDIR /opt
COPY --from=builder /opt/mat /opt/mat
COPY run.sh ./mat
WORKDIR /data
ENTRYPOINT ["/opt/mat/run.sh"]
