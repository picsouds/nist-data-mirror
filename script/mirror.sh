#!/bin/sh

echo "Updating..."
java $JAVA_OPTS -jar /app/nist-data-mirror.jar /usr/local/apache2/htdocs

