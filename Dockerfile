FROM xena/nim:0.15.0

EXPOSE 5000
RUN adduser -D -g '' r

ADD . /app

WORKDIR /app
RUN nimble update &&\
    yes | nimble build &&\
    yes | nimble install &&\
    cp ~/.nimble/bin/ponyapi /usr/bin/ponyapi

USER r
CMD /usr/bin/ponyapi
