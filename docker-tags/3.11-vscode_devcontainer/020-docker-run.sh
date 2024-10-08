#!/bin/bash

. ./env

# --------------------
#
# Runs the image for testing.
#
# --------------------
docker run -ti --rm \
  --user vscode:vscode \
  --name python_test \
  -v $(pwd):$(pwd) \
  --workdir $(pwd) \
  $IMAGE_NAME
