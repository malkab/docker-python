#!/bin/bash

# Runs a Docker Python session
docker run -ti --rm \
    --name python_test \
    --user 1000:1000 \
    -v $(pwd):$(pwd) \
    --workdir $(pwd) \
    malkab/python:3.9-buster
