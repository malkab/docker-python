#!/bin/bash

# Runs a Docker Python session

mlkdckpythonrun -q \
  -u 1000:1000 \
  -w $(pwd) \
  -v $(pwd):$(pwd) \
  -i docker_python_test \
  3.9-buster
