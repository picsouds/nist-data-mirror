FROM alpine/git AS gitclone
WORKDIR /app
RUN git clone https://github.com/stevespringett/nist-data-mirror.git

FROM maven:3.5-jdk-8-alpine AS maven
WORKDIR /app
COPY --from=gitclone /app/nist-data-mirror /app
RUN mvn clean package

FROM httpd:alpine

ARG http_proxy
ARG https_proxy
ARG no_proxy

WORKDIR /app

COPY --from=maven /app/target/nist-data-mirror.jar /app
COPY httpd.conf /usr/local/apache2/conf/

RUN apk update && \
    apk add --no-cache openjdk8-jre && \
    rm -f /usr/local/apache2/htdocs/*.html && \
    echo '0 */4 * * * java $JAVA_OPTS -jar /app/nist-data-mirror.jar /usr/local/apache2/htdocs' > /etc/crontabs/root            

# Running the recovery at launch
CMD (java $JAVA_OPTS -jar /app/nist-data-mirror.jar /usr/local/apache2/htdocs) && ( crond -f -l 2 & ) && httpd -D FOREGROUND
