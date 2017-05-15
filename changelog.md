v0.3.1
-Small tutorial and logging fixes

v0.3.0
-Updated and simplified installation instructions
-Added support for debian 8.8
-Improved tomcat service memory configuration depending on amount of memory available
-Improved jdk detection and installation
-Fixed problem when a jdk is already installed
-Fixed tomcat download link
-Fixed & improved installer logging
-Added script parameters so some parts are not executed
-Tomcat & jobsworth binaries are now downloaded into the same folder as the installer
-Support continue for failed downloads of Tomcat & jobsworth


Tested with:
Ubuntu: Server 16.10, Debian: 8.8
Jobsworth: 5.0 beta 2
MySql: mariadb-server 10.0.29
Java JDK: java-1.8.0-openjdk-amd64
Tomcat: v8.5.15


v0.2.0

Changes
-Added support for ubuntu 15.04
-Changed db engine from mysql to mariadb (be careful if you already use mysql you can choose not to install it)
-Instead of default jdk, the installer now uses openJDK 8
-Tomcat version used is now the stable one (8.5.14)
-Fixed & improved installer logging
-improved tomcat service memory configuration

Tested with:
Ubuntu: Desktop 16.10, Server 16.10, Server 15.04
Jobsworth: 5.0 beta 2
MySql: mariadb-server 10.0.25
Java JDK: java-1.8.0-openjdk-amd64
Tomcat: v8.5.14



v0.1.0
This installer was tested on:
Ubuntu: Desktop 16.10, Server 16.10
Jobsworth: 5.0 beta 2
MySql: mysql-server 5.7.17
Java JDK: java-1.8.0-openjdk-amd64
Tomcat: v9.0.0.M19
