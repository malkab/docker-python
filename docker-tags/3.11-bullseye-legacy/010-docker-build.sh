#!/bin/bash

# --------------------
#
# Builds the image.
#
# --------------------
cd assets/node-18.14.0
rm -Rf node node-*
tar -xf node.tar.xz
mv node-v18.14.0-linux-x64 node
cd ../..

docker build --no-cache --force-rm -t malkab/python:3.11-bullseye .
