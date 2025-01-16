FROM mcr.microsoft.com/devcontainers/python:3.12-bookworm AS build

LABEL author="Juan Pedro Perez"
LABEL email="jp.perez.alcantara@gmail.com"

WORKDIR /

USER root

ADD assets/fzf /usr/local/bin/
ADD assets/dot.bashrc /home/vscode/.bashrc
ADD assets/dot.vimrc /home/vscode/.vimrc

RUN chown vscode:vscode /home/vscode/.bashrc && \
    chown vscode:vscode /home/vscode/.vimrc

RUN apt-get update

# Locale
ENV LOCALE=es_ES.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime

RUN apt-get install -y \
      debconf-utils \
      libreadline8 \
      locales \
      tzdata && ldconfig

RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
      sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen && \
      sed -i -e 's/# en_US.ISO-8859-15 ISO-8859-15/en_US.ISO-8859-15 ISO-8859-15/' /etc/locale.gen && \
      sed -i -e 's/# en_GB ISO-8859-1/en_GB ISO-8859-1/' /etc/locale.gen && \
      sed -i -e 's/# en_GB.ISO-8859-15 ISO-8859-15/en_GB.ISO-8859-15 ISO-8859-15/' /etc/locale.gen && \
      sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
      sed -i -e 's/# es_ES ISO-8859-1/es_ES ISO-8859-1/' /etc/locale.gen && \
      sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen && \
      sed -i -e 's/# es_ES@euro ISO-8859-15/es_ES@euro ISO-8859-15/' /etc/locale.gen && \
      sed -i -e 's/# de_DE ISO-8859-1/de_DE ISO-8859-1/' /etc/locale.gen && \
      sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
      sed -i -e 's/# de_DE@euro ISO-8859-15/de_DE@euro ISO-8859-15/' /etc/locale.gen && \
      sed -i -e 's/# fr_FR ISO-8859-1/fr_FR ISO-8859-1/' /etc/locale.gen && \
      sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
      sed -i -e 's/# fr_FR@euro ISO-8859-15/fr_FR@euro ISO-8859-15/' /etc/locale.gen && \
      sed -i -e 's/# it_IT ISO-8859-1/it_IT ISO-8859-1/' /etc/locale.gen && \
      sed -i -e 's/# it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen && \
      sed -i -e 's/# it_IT@euro ISO-8859-15/it_IT@euro ISO-8859-15/' /etc/locale.gen

RUN locale-gen && update-locale LANG=$LOCALE

# Instalaciones de paquete
RUN apt-get install -y -f \
  mkdocs \
  apt-utils \
  bat \
  curl \
  fd-find \
  inotify-tools \
  less \
  mlocate \
  p7zip-full \
  vim \
  x11-apps

RUN apt-get -y upgrade && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    ldconfig

RUN ln -s /usr/bin/batcat /usr/bin/bat

RUN updatedb

USER vscode

RUN python -m pip install --upgrade --break-system-packages pip

RUN python -m pip install --upgrade --break-system-packages \
  build \
  ipython \
  mkdocs-material \
  mkdocstrings \
  mkdocstrings-python \
  pyinstaller \
  pytest \
  pytest-watch \
  readline

RUN python3 -m pip install pipx && \
    python3 -m pipx ensurepath

# Aplanamiento
FROM scratch

COPY --from=build / /
