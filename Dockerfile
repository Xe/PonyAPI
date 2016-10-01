FROM xena/nim:0.15.0

ENV BACKPLANE_PROXY_URL http://127.0.0.1:5000

ARG labels
ENV BACKPLANE_LABELS $labels
ARG domain
ENV DOMAIN $domain

COPY . /app
WORKDIR /app
RUN nimble update &&\
    yes | nimble build

CMD ./ponyapi
