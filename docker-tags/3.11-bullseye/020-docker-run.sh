#!/bin/bash

# --------------------
#
# Runs the image for testing.
#
# --------------------
docker run -ti --rm \
  -p 8080:8080 \
  --user 1000:1000 \
  --name python_test \
  -v $(pwd):$(pwd) \
  --workdir $(pwd) \
  malkab/python:3.11-bullseye
