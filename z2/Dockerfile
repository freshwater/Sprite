

FROM ubuntu:latest

RUN apt-get update
RUN apt-get install --yes git

RUN apt-get install --yes nodejs
RUN apt-get install --yes python3.8

RUN git clone https://github.com/pegjs/pegjs.git 

## RUN apt-get install --yes wget
## RUN wget https://swift.org/builds/swift-4.2.1-release/ubuntu1804/swift-4.2.1-RELEASE/swift-4.2.1-RELEASE-ubuntu18.04.tar.gz
## RUN tar -xvzf swift-4.2.1-RELEASE-ubuntu18.04.tar.gz
## 
## RUN export PATH=swift-4.2.1-RELEASE-ubuntu18.04/usr/bin:"${PATH}"
## 
## RUN echo
## RUN ls -al swift-4.2.1-RELEASE-ubuntu18.04/usr/bin
## 
## RUN cat /etc/issue
## 
## RUN apt-get install --yes gcc-aarch64-linux-gnu
## ENV PATH="swift-4.2.1-RELEASE-ubuntu18.04/usr/bin:${PATH}"
## RUN swift
## 
## RUN 1

WORKDIR /build

COPY SpriteParse.js .
COPY SpriteGrammar.pegjs .
COPY SpriteCompile.py .

VOLUME /workfolder

ENTRYPOINT ["python3.8", "SpriteCompile.py"]

# COPY template_python.py .
# RUN python3.8 template_python.py


