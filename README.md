# NVD NIST Mirror Docker

This is a Docker image wrapping [Steve Springett's NIST Data Mirror](https://github.com/stevespringett/nist-data-mirror).  

Since the NVD NIST server has enforced a rather forceful rate-limiting, such proxies are required to be able to analyze dependency vulnerabilities, with tools such as [OWASP's Dependency Check](https://www.owasp.org/index.php/OWASP_Dependency_Check).
This Docker image provides this functionality. The vulnerabilities will update every day every 4 hours (crond)

Apache Bootstrap & Bootswatch Autoindex with [abba](https://github.com/jmlemetayer/abba)

## Usage

If a proxy, or JVM customization are required, the $JAVA_OPTS environment variable translates to the mirror's call.

## Build local image 
```
- git clone https://github.com/picsouds/nist-data-mirror-docker.git
- docker build --rm -t picsouds/nvdmirror:latest  .
- docker run -d -p 8080:8080 -e JAVA_OPTS='' --name test picsouds/nvdmirror:latest
```
## TEST with [DependencyCheck](https://github.com/jeremylong/DependencyCheck)
```
- Download the latest release and unzip
- ./bin/dependency-check.sh  --updateonly  -cveUrlBase 'http://localhost:8080/nvdcve-1.1-%d.json.gz' --cveUrlModified 'http://localhost:8080/nvdcve-1.1-modified.json.gz'
```



