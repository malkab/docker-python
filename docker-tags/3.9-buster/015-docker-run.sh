#!/bin/bash

# Version: 2021-03-17

# -----------------------------------------------------------------
#
# Document here the purpose of the script.
#
# -----------------------------------------------------------------
#
# Runs an arbitrary container.
#
# -----------------------------------------------------------------
# Check mlkctxt to check. If void, no check will be performed. If NOTNULL,
# any activated context will do, but will fail if no context was activated.
MATCH_MLKCTXT=
# Custom command or path to script (relative to WORKDIR) to execute, for example
# "/bin/bash -c \"ls -lh\"". Leave blank for using the image's built-in option.
# This has a strong interaction with the ENTRYPOINT parameter.
COMMAND=
# The network to connect to. Remember that when attaching to the network of an
# existing container (using container:name) the HOST is "localhost". Also the
# host network can be connected using just "host".
NETWORK=
# Container identifier root. This is used for both the container name (adding an
# UID to avoid clashing) and the container host name (without UID). Incompatible
# with NETWORK container:name option. If blank, a Docker engine default name
# will be assigned to the container.
ID_ROOT=docker_python_test
# Unique? If true, no container with the same name can be created. Defaults to
# true.
UNIQUE=false
# Work dir. Use $(pwd) paths. Defaults to /.
WORKDIR=$(pwd)
# Run mode. Can be PERSISTABLE (-ti), VOLATILE (-ti --rm), or DAEMON (-d). If
# blank, defaults to VOLATILE.
RUN_MODE=
# The name of the image to pull, without tag. Defaults to ubuntu.
IMAGE_NAME=malkab/python
# The GRASS Docker image tag to use. Defaults to latest.
IMAGE_TAG=
# Declare volumes, a line per volume, complete in source:destination form. No
# strings needed, $(pwd)/../data/:/ext_src/ works perfectly. Defaults to ().
VOLUMES=($(pwd):$(pwd))
# Env vars. Use ENV_VAR_NAME_CONTAINER=ENV_VAR_NAME_HOST format. Defaults to ().
ENV_VARS=(
  PYTHONGROUPID=1000
  PYTHONUSERID=1000
)
# Replicas. If VOLATILE is true will fail. Keep in mind replicas will share
# volumes and all other configuration set. They'll be named with a _# suffix.
# Keep blank for no replicas. Needs the ID_ROOT parameter to be defined.
REPLICAS=
# Open ports in the form (external:internal external:internal).
PORTS=
# Custom entrypoint, leave blank for using the image's built-in option.
ENTRYPOINT=
# The following options are mutually exclusive. Use display for X11 host server
# in Mac? Defaults to false.
X11_MAC=
# Use display for X11 host server in Linux? Defaults to false.
X11_LINUX=
# User UID and GID in the UID:GID form. Defaults to 0:0.
USER=





# ---

# Check mlkctxt is present at the system
if command -v mlkctxt &> /dev/null ; then

  if ! mlkctxt -c $MATCH_MLKCTXT ; then exit 1 ; fi

fi

# Manage identifier
if [ ! -z "${ID_ROOT}" ] ; then

  N="${ID_ROOT}_$(mlkctxt)"
  CONTAINER_HOST_NAME_F="--hostname ${N}"

  if [ "${UNIQUE}" = false ] ; then

    CONTAINER_NAME_F="--name ${N}_$(uuidgen)"

  else

    CONTAINER_NAME_F="--name ${N}"

  fi

fi

# Network
if [ ! -z "${NETWORK}" ]; then NETWORK="--network=${NETWORK}" ; fi

# Env vars
ENV_VARS_F=

if [ ! -z "${ENV_VARS}" ] ; then

  for E in "${ENV_VARS[@]}" ; do

    ARR_E=(${E//=/ })

    ENV_VARS_F="${ENV_VARS_F} -e ${ARR_E[0]}=${ARR_E[1]} "

  done

fi

# Image name
IMAGE_NAME_F=ubuntu
if [ ! -z "${IMAGE_NAME}" ]; then IMAGE_NAME_F=$IMAGE_NAME ; fi

# Image tag
IMAGE_TAG_F=latest
if [ ! -z "${IMAGE_TAG}" ] ; then IMAGE_TAG_F=$IMAGE_TAG ; fi

# Default X11
X11_F=

# X11 for Mac
if [ "${X11_MAC}" = true ] ; then

  X11_F="-e DISPLAY=host.docker.internal:0"

  # Prepare XQuartz server
  xhost + 127.0.0.1

fi

# X11 for Linux
if [ "${X11_LINUX}" = true ] ; then

  # This is for newer Ubuntus
  X11_F="-e DISPLAY -v $XAUTHORITY:/root/.Xauthority:rw"
  # This is for older Ubuntus
  # X11="-e DISPLAY -v $HOME/.Xauthority:/root/.Xauthority:rw"

fi

# Workdir
WORKDIR_F="--workdir /"
if [ ! -z "${WORKDIR}" ] ; then WORKDIR_F="--workdir ${WORKDIR}" ; fi

# Volumes
VOLUMES_F=

if [ ! -z "${VOLUMES}" ] ; then

  for E in "${VOLUMES[@]}" ; do

    VOLUMES_F="${VOLUMES_F} -v ${E} "

  done

fi

# Ports
PORTS_F=

if [ ! -z "${PORTS}" ] ; then

  for E in "${PORTS[@]}" ; do

    PORTS_F="${PORTS_F} -p ${E} "

  done

fi

# Run mode
if [ ! -z "$RUN_MODE" ] ; then

  if [ "$RUN_MODE" = "PERSISTABLE" ] ; then

    COMMAND_DOCKER="docker run -ti"

  elif [ "$RUN_MODE" = "VOLATILE" ] ; then

    COMMAND_DOCKER="docker run -ti --rm"

  elif [ "$RUN_MODE" = "DAEMON" ] ; then

    COMMAND_DOCKER="docker run -d"

  else

    echo Error: unrecognized RUN_MODE $RUN_MODE, exiting...
    exit 1

  fi

else

  COMMAND_DOCKER="docker run -ti --rm"

fi

# Entrypoint
ENTRYPOINT_F=

if [ ! -z "${ENTRYPOINT}" ] ; then

  ENTRYPOINT_F="--entrypoint ${ENTRYPOINT}"

fi

# User
USER_F="--user 0:0"
if [ ! -z "${USER}" ] ; then USER_F="--user ${USER}" ; fi



# Iterate to produce replicas if VOLATILE is false
if [ ! -z "$REPLICAS" ] ; then

  if [ "$VOLATILE" = true ] ; then

    echo VOLATILE true and REPLICAS not blank are incompatible options

    exit 1

  fi

  for REPLICA in $(seq 1 $REPLICAS) ; do

    eval  $COMMAND_DOCKER \
          $NETWORK \
          ${CONTAINER_NAME}-${REPLICA} \
          ${CONTAINER_HOST_NAME}-${REPLICA} \
          $X11_F \
          $VOLUMES_F \
          $PORTS_F \
          $ENTRYPOINT \
          $WORKDIR_F \
          $ENV_VARS_F \
          $USER_F \
          $IMAGE_NAME_F:$IMAGE_TAG_F \
          $COMMAND

  done

else

  eval  $COMMAND_DOCKER \
          $NETWORK \
          $CONTAINER_NAME_F \
          $CONTAINER_HOST_NAME_F \
          $VOLUMES_F \
          $X11_F \
          $PORTS_F \
          $ENTRYPOINT_F \
          $WORKDIR_F \
          $ENV_VARS_F \
          $USER_F \
          $IMAGE_NAME_F:$IMAGE_TAG_F \
          $COMMAND

fi
