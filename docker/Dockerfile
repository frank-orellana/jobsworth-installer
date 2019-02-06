FROM tomcat:latest

LABEL mantainer "Frank Orellana <frank.orellana@tritium.cl>"

ADD installer-resources ./installer-resources
ADD install-jobsworth.sh .

RUN /bin/bash install-jobsworth.sh

EXPOSE 8080