FROM eclipse-temurin:8-jre-alpine

LABEL org.opencontainers.image.authors="Priyanshi Sarad <itspriyanshisarad@gmail.com>"

RUN apk add --no-cache bash wget tar

RUN wget -O /tmp/activemq.tar.gz \
      http://archive.apache.org/dist/activemq/5.14.3/apache-activemq-5.14.3-bin.tar.gz && \
    tar -xzf /tmp/activemq.tar.gz -C /opt && \
    rm -f /tmp/activemq.tar.gz

EXPOSE 61616 8161

CMD ["/opt/apache-activemq-5.14.3/bin/activemq", "console"]
