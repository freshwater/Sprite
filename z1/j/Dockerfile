
FROM ubuntu:latest

RUN apt-get update
RUN apt-get install --yes wget
RUN apt-get install libedit2

RUN wget http://www.jsoftware.com/download/j806/install/j806_linux64.tar.gz
RUN tar xvzf j806_linux64.tar.gz

WORKDIR /workfolder

ENTRYPOINT ["/bin/bash", "-c", "/j64-806/jconsole.sh"]

