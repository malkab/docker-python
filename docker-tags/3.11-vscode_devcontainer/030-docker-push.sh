#!/bin/bash

. ./env

# --------------------
#
# Push the image to DockerHub, public.
#
# --------------------
docker push $IMAGE_NAME
