# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# This is a manifest designed to be used with box[1]. Build it using:
#
#    $ box box.rb
#
# [1]: https://github.com/erikh/box

from "xena/nim:0.16.0"

env "BACKPLANE_PROXY_URL" => "http://127.0.0.1:5000"

copy "ponyapi.nimble", "/app/ponyapi.nimble"
copy "src",            "/app/src/"
copy "public",         "/app/public/"
copy "fim.list",       "/app/fim.list"

run "cd /app && nimble update && yes | nimble build"

entrypoint "/entrypoint.sh"
cmd "./ponyapi"

run %q[ rm -rf /root/.nimble /opt ./src/nimcache && apk del libc-dev gcc curl libgcc git perl xz tar nim-compiler-deps ]

flatten

run "apk add --no-cache pcre backplane-runit"

tag "xena/ponyapi"
