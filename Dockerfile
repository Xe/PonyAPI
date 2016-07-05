FROM xena/nim:0.14.2

RUN apk update && apk add bash

EXPOSE 5000
RUN adduser -D -g '' r
RUN chmod a+x /opt/Nim/bin/nim

ADD . /app

WORKDIR /app
RUN nimble update &&\
    yes | nimble install &&\
    nim c -d:release --deadCodeElim:on ponyapi

USER r
CMD ./ponyapi
