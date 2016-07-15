FROM xena/nim:0.14.2

RUN apk update && apk add bash

EXPOSE 5000
RUN adduser -D -g '' r
RUN chmod a+x /opt/Nim/bin/nim

ADD . /app

WORKDIR /app
RUN nimble update &&\
    yes | nimble build &&\
    yes | nimble install &&\
    cp ~/.nimble/bin/ponyapi /usr/bin/ponyapi

USER r
CMD /usr/bin/ponyapi
