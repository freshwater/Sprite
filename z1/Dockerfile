

FROM ubuntu:latest

RUN apt-get update
RUN apt-get install --yes git

RUN apt-get install --yes nodejs
RUN apt-get install --yes python3.8

RUN git clone https://github.com/pegjs/pegjs.git 

WORKDIR /build/pegjs
RUN cp -r ../../pegjs/lib/* .

RUN echo 2

WORKDIR /build
COPY test.js .
COPY grammar.pegjs .
COPY structure.py .

COPY template_dockerfile .

# RUN node test.js
# RUN cat structure.js

VOLUME /io

ENTRYPOINT ["python3.8", "structure.py"]

# COPY template_python.py .
# RUN python3.8 template_python.py

