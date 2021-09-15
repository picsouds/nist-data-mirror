FROM httpd:alpine
WORKDIR /app
COPY script/nist-data-mirror.jar /app
RUN apk update && \
    apk add --no-cache openjdk8-jre && \
    rm -f /usr/local/apache2/htdocs/*.html && \
    echo '0 */4 * * * java $JAVA_OPTS -jar /app/nist-data-mirror.jar /usr/local/apache2/htdocs' > /etc/crontabs/root

# Running the recovery at launch
CMD (java $JAVA_OPTS -jar /app/nist-data-mirror.jar /usr/local/apache2/htdocs) && ( crond -f -l 2 & ) && httpd -D FOREGROUND
