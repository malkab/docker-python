FROM python:3.11-bullseye

LABEL author="Juan Pedro Perez"
LABEL email="jp.perez.alcantara@gmail.com"

WORKDIR /

ADD assets/dot.bashrc /root/.bashrc
ADD assets/dot.vimrc /root/.vimrc
ADD assets/dot.bashrc /etc/skel/.bashrc
ADD assets/dot.vimrc /etc/skel/.vimrc
ADD assets/sudoers /

# Copy and run setup
ADD assets/configure.sh /
RUN chmod 777 /configure.sh ; \
  /configure.sh ; \
  rm /configure.sh

ENTRYPOINT [ "/bin/bash" ]
