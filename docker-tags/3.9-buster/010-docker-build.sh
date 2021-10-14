#!/bin/bash

# Version: 2021-06-08

# -----------------------------------------------------------------
#
# Builds the image.
#
# -----------------------------------------------------------------
#
# Builds a Docker image.
#
# -----------------------------------------------------------------
# Check mlkctxt to check. If void, no check will be performed. If NOTNULL,
# any activated context will do, but will fail if no context was activated.
MATCH_MLKCTXT=
# The name of the image to build. Mandatory.
IMAGE_NAME=malkab/python
# The tags. An array of tags in the form (tagA tagB) to create as many images
# as tags. Defaults to (latest).
IMAGE_TAGS=(3.9-buster latest)
# Dockerfile. Defaults to ".".
DOCKERFILE=
# Build args, an array of (ARG_NAME=ARG_VALUE ARG_NAME=ARG_VALUE) structure
# to add --build-arg parameters to the build. Defaults to ().
BUILD_ARGS=
# Cache usage. True by default.
USE_CACHE=
# Remove intermediate containers. True by default.
REMOVE_INTERMEDIATE_CONTAINERS=





# ---

# Check mlkctxt is present at the system
if command -v mlkctxt &> /dev/null
then

  if ! mlkctxt -c $MATCH_MLKCTXT ; then exit 1; fi

fi

# Process tags
IMAGE_TAGS_F=(latest)
if [ ! -z "$IMAGE_TAGS" ] ; then IMAGE_TAGS_F=("${IMAGE_TAGS[@]}") ; fi

# Process Dockerfile
DOCKERFILE_F=.
if [ ! -z "$DOCKERFILE" ] ; then DOCKERFILE_F=$DOCKERFILE ; fi

# Cache usage
USE_CACHE_F=
if [ ! -z "$USE_CACHE" ] ; then USE_CACHE_F="--no-cache" ; fi

# Remove intermediate containers
REMOVE_INTERMEDIATE_CONTAINERS_F="--force-rm"
if [ ! -z "$REMOVE_INTERMEDIATE_CONTAINERS" ] ; then REMOVE_INTERMEDIATE_CONTAINERS_F="--no-rm" ; fi

# Build the image with the firts image tag, removing it
FIRST_TAG=${IMAGE_TAGS_F[0]}
IMAGE_TAGS_F_REST=("${IMAGE_TAGS_F[@]:1}")

# Add build-args
BUILD_ARGS_F=

if [ ! -z "${BUILD_ARGS}" ] ; then

  for E in "${BUILD_ARGS[@]}" ; do

    ARR_E=(${E//=/ })

    BUILD_ARGS_F="${BUILD_ARGS_F} --build-arg ${ARR_E[0]}=${ARR_E[1]} "

  done

fi

echo "BUILDING BASE IMAGE WITH TAG: ${IMAGE_NAME}:${FIRST_TAG}"
echo -------------

# Build
eval docker build \
  $BUILD_ARGS_F \
  $USE_CACHE_F \
  $REMOVE_INTERMEDIATE_CONTAINERS_F \
  -t $IMAGE_NAME:$FIRST_TAG \
  $DOCKERFILE_F

# Tag remaining ones
for T in "${IMAGE_TAGS_F_REST[@]}" ; do

  echo -------------
  echo "BUILDING BASE IMAGE WITH TAG: ${IMAGE_NAME}:${T}"
  echo -------------

  eval docker tag $IMAGE_NAME:$FIRST_TAG $IMAGE_NAME:$T

done
