ARG http_proxy
ARG https_proxy
ARG no_proxy

FROM alpine/git AS gitclone
WORKDIR /app
RUN git clone https://github.com/stevespringett/nist-data-mirror.git

FROM maven:3.8.2-openjdk-17 AS maven
WORKDIR /app
COPY --from=gitclone /app/nist-data-mirror /app
RUN mvn clean package

FROM httpd:alpine

ENV USER=mirror
ENV TZ=Europe/Paris

WORKDIR /app

COPY --from=maven /app/target/nist-data-mirror.jar /app
COPY ["script/mirror.sh", "/app/mirror.sh"]

RUN apk update && \
    apk add --no-cache openjdk11-jre tzdata supervisor dcron && \
    rm -f /usr/local/apache2/htdocs/*.html                   && \
    addgroup -S $USER                                        && \
    adduser -S $USER -G $USER                                && \
    chown -R $USER:$USER /usr/local/apache2/htdocs           && \
    chown -R $USER:$USER /app                                && \                                  
    chmod +x /app/mirror.sh                                  && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime

# Conf 
COPY [".abba/" , "/usr/local/apache2/htdocs/.abba"]
COPY ["conf/httpd.conf", "/usr/local/apache2/conf/"]
COPY ["conf/supervisord.conf", "/etc/supervisor/conf.d/supervisord.conf"]
COPY ["crontab/mirror", "/etc/crontabs/${USER}"]

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf", "-l", "/var/log/supervisord.log", "-j", "/var/run/supervisord.pid"]
