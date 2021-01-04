#!/bin/bash

# Version: 2020-11-19

# -----------------------------------------------------------------
#
# Document the script purpose here.
#
# -----------------------------------------------------------------
#
# Pushes images to the GitLab registry with confirmation.
#
# -----------------------------------------------------------------

# Check mlkcontext to check. If void, no check will be performed.
MATCH_MLKCONTEXT=
# A set of images to upload, in the form (image0 image1). Could be multiline
# inside the parentheses. Provide the full image names as shown in docker
# images.
IMAGES=(
  malkab/python:3.9-buster
  malkab/python:latest
)
# The user for login. Leave blank if the default DockerHub repo is going to be
# used.
USER=$MLKC_GITLAB_USER
# The registry for login. Leave blank if the default DockerHub repo is going to
# be used.
REGISTRY=$MLKC_GITLAB_REGISTRY





# ---

# Check mlkcontext is present at the system
if command -v mlkcontext &> /dev/null
then

  echo -------------
  echo WORKING AT $(mlkcontext)
  echo -------------

  # Check mlkcontext
  if [ ! -z "${MATCH_MLKCONTEXT}" ] ; then

    if [ ! "$(mlkcontext)" = "$MATCH_MLKCONTEXT" ] ; then

      echo Please initialise context $MATCH_MLKCONTEXT
      exit 1

    fi

  fi

fi


if [ ${#IMAGES[@]} == 0 ]; then

  echo "No images defined, exiting..."

  exit 1

fi


if [ ! -z "${USER}" ] ; then

  echo Please provide registry credentials, if GitLab, this implies an API token...

  docker login $REGISTRY -u $USER

fi


for IMAGE in "${IMAGES[@]}" ; do

  echo -------------
  echo PUSHING IMAGE ${IMAGE}
  echo -------------
  docker push $IMAGE

done
