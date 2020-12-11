FROM alpine:3.11

LABEL maintainer="keshav143420@gmail.com"

ARG html_page_name="ide"

RUN apk add --update --no-cache build-base git python2 tmux npm curl bash zip\
 && rm -rf /var/cache/apk/*

ENV NVM_VERSION v0.33.11
ENV NODE_VERSION 10.14.2
ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN source $NVM_DIR/nvm.sh
RUN nvm install $NODE_VERSION
RUN nvm alias default $NODE_VERSION
RUN nvm use default

RUN git clone https://github.com/c9/core.git /root/.c9 \
 && cd /root/.c9 \
 && mkdir -p ./node/bin ./bin ./node_modules \
 && ln -sf "`which tmux`" ./bin/tmux \
 && ln -s "`which node`" ./node/bin/node \
 && ln -s "`which npm`" ./node/bin/npm \
 && npm install pty.js \
 && echo 1 > ./installed \
 && NO_PULL=1 ./scripts/install-sdk.sh \
 && rm -rf /tmp/* \
 && bash -c "sed -i 's#/ide.html#/'$html_page_name'.html#g' ./plugins/c9.vfs.standalone/standalone.js" \
 && mkdir /workspace

VOLUME /workspace

WORKDIR /workspace

EXPOSE 8080/tcp

ENV C9USER="c9user" C9PASSWORD="c9password"

ENTRYPOINT ["/bin/sh", "-c", "/usr/bin/node /root/.c9/server.js -p 8080 -w /workspace/ -l 0.0.0.0 -a $C9USER:$C9PASSWORD"]