FROM coopernurse/docker-nim

EXPOSE 5000
RUN adduser -D -g '' r
RUN chmod a+x /root/.nimble/bin/nimble

ADD . /app

WORKDIR /app
RUN nimble update &&\
    yes | nimble install &&\
    nim c -d:release --deadCodeElim:on ponyapi

USER r
CMD ./ponyapi
