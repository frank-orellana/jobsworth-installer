FROM tomcat:latest

LABEL mantainer "Frank Orellana <frank.orellana@tritium.cl>"

ADD installer-resources ./installer-resources
ADD install-jobsworth-docker.sh .

RUN /bin/bash install-jobsworth-docker.sh

EXPOSE 8080