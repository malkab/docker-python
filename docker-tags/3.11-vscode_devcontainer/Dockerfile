FROM mcr.microsoft.com/devcontainers/python:3.11-bookworm

LABEL author="Juan Pedro Perez"
LABEL email="jp.perez.alcantara@gmail.com"

WORKDIR /

USER root

ADD assets/setup_dev_basics.sh /
ADD assets/fzf /usr/local/bin/
ADD assets/dot.bashrc /home/vscode/.bashrc
ADD assets/dot.vimrc /home/vscode/.vimrc

RUN chown vscode:vscode /home/vscode/.bashrc && \
    chown vscode:vscode /home/vscode/.vimrc

RUN chmod 777 /setup_dev_basics.sh ; \
/setup_dev_basics.sh

RUN apt-get install -y -f mkdocs

RUN mkdir /home/git && \
    chown -R vscode:vscode /home/git

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

RUN sudo updatedb

ENTRYPOINT [ "/bin/bash" ]
