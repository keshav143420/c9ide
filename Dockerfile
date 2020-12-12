FROM ubuntu:18.04

# Use bash
# by keshav
RUN rm /bin/sh && ln -sf /bin/bash /bin/sh

# Install Prereqs
RUN apt-get update --fix-missing && DEBIAN_FRONTEND=noninteractive  \
  apt-get install \
  # Installation deps and tools
  apt-transport-https ca-certificates curl software-properties-common \
  build-essential python2.7 sshfs zip unzip tzdata\
  dnsutils bash-completion xsltproc \
  build-essential fakeroot tmux duplicity lftp htop apt-file \
  parallel strace ltrace flex jq ack-grep gdb valgrind locate tree time \
  zip unp cmake \
  # Dev tools
  vim git zsh -y && \
  # Node (C9 needs v6)
  curl --silent --location https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install nodejs -y

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8
# Install C9
RUN git clone git://github.com/c9/core.git /c9 && \
  /c9/scripts/install-sdk.sh

# Create workspace
RUN mkdir /workspace

# Start C9
CMD node /c9/server.js -p $C9PORT -a $C9USER:$C9PASS --listen 0.0.0.0 -w /workspace