# NVD NIST Mirror Docker

This is a Docker image wrapping [Steve Springett's NIST Data Mirror](https://github.com/stevespringett/nist-data-mirror).

Since the NVD NIST server has enforced a rather forceful rate-limiting, such proxies are required to be able to analyze dependency vulnerabilities, with tools such as [OWASP's Dependency Check](https://www.owasp.org/index.php/OWASP_Dependency_Check).
This Docker image provides this functionality. The vulnerabilities will update themselves everyday, at 1 am.

## Usage

If a proxy, or JVM customization are required, the $JAVA_OPTS environment variable translates to the mirror's call.
