# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# This is a manifest designed to be used with box[1]. Build it using:
#
#    $ box box.rb
#
# [1]: https://github.com/erikh/box

from "xena/nim:0.17.2"

env "BACKPLANE_PROXY_URL" => "http://127.0.0.1:5000"
env "ROUTE_BACKEND" => "http://127.0.0.1:5000"
env "PORT" => "5000"

copy "run.sh",         "/run.sh"
copy "ponyapi.nimble", "/app/ponyapi.nimble"
copy "src",            "/app/src/"
copy "public",         "/app/public/"
copy "fim.list",       "/app/fim.list"

run "cd /app && nimble update && yes | nimble build"

run %q[ rm -rf /root/.nimble /opt ./src/nimcache && apk del libc-dev gcc curl libgcc git perl xz tar nim-compiler-deps && apk add --no-cache pcre ]

flatten

tag "xena/ponyapi:slim"

run "apk add --no-cache backplane-runit route-mesh-runit"
cmd "/run.sh"

tag "xena/ponyapi"
