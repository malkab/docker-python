#!/bin/bash

. ./env

# --------------------
#
# Builds the image.
#
# --------------------
docker build --force-rm -t $IMAGE_NAME .
