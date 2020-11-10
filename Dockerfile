FROM groovy:3.0.6

ENV REVIEWDOG_VERSION=v0.11.0
ENV CODENARC_VER=2.0.0
ENV SLF4J_VER=1.7.30
ENV GMETRICS_VERSION=1.1
ENV GROOVY_JAR=$GROOVY_HOME/lib/*
ENV HOME_JARS=/home/groovy/*

USER root

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

USER groovy

# RUN wget -q https://github.com/CodeNarc/CodeNarc/releases/download/v$CODENARC_VER/CodeNarc-$CODENARC_VER.jar
RUN wget -q https://repo1.maven.org/maven2/org/slf4j/slf4j-api/$SLF4J_VER/slf4j-api-$SLF4J_VER.jar
RUN wget -q https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/$SLF4J_VER/slf4j-simple-$SLF4J_VER.jar
RUN wget -q https://github.com/dx42/gmetrics/releases/download/v$GMETRICS_VERSION/gmetrics-$GMETRICS_VERSION.jar

COPY CodeNarc-$CODENARC_VER.jar CodeNarc-$CODENARC_VER.jar
COPY codenarc /usr/bin
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
