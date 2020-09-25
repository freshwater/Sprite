
FROM ubuntu:latest

RUN apt-get update
RUN apt-get install --yes erlang

# RUN ls -al /usr/lib/erlang/releases

# RUN apt-get install -y python3.8



WORKDIR /build


COPY /bin/1953725179319274976 .

VOLUME /io
WORKDIR /io

# CMD ["erl"]
# ENTRYPOINT ["erl", "-pa", "ebin", "-eval", "application:start(module1)."]
ENTRYPOINT ["escript", "/build/1953725179319274976"]


