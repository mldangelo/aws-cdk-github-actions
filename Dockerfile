# Build Stage
FROM alpine:3.18 as builder

ARG NODE_VERSION=18.18.0
ARG NPM_VERSION=9.8.1
ARG PYTHON_VERSION=3.8.10
ENV NVM_DIR /usr/local/nvm

RUN apk --no-cache add bash curl git jq build-base libffi-dev openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | PROFILE=/dev/null bash

RUN . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    npm install -g npm@$NPM_VERSION

RUN apk --no-cache add git bash build-base openssl readline libffi && \
    curl https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
    /root/.pyenv/bin/pyenv install $PYTHON_VERSION && \
    /root/.pyenv/bin/pyenv global $PYTHON_VERSION

# Runtime Stage
FROM alpine:3.18

COPY --from=builder /usr/local/nvm $NVM_DIR
COPY --from=builder /root/.pyenv /root/.pyenv

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:/root/.pyenv/bin:$PATH

RUN apk --no-cache add docker && \
    curl -o go.tar.gz https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz && \
    rm -rf /var/cache/apk/*

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY entrypoint.sh ./

ENTRYPOINT ["/app/entrypoint.sh"]
