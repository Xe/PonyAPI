#!/bin/sh

set -e

nim c -d:ssl --hints:off -r ponyapi
