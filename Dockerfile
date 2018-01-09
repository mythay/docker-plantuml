FROM maven:3-jdk-8 AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends graphviz fonts-wqy-zenhei && \
    apt-get clean

COPY pom.xml /app/
COPY src /app/src/

ENV MAVEN_CONFIG=/app/.m2
WORKDIR /app
RUN mvn package

########################################################################################

FROM jetty
MAINTAINER D.Ducatel

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends graphviz fonts-wqy-zenhei && \
    apt-get clean

USER jetty

COPY --from=builder /app/target/plantuml.war /var/lib/jetty/webapps/plantuml.war
