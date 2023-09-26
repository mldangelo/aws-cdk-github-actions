# Build Stage
FROM alpine:3.18 as builder

# Set desired Node.js version, NVM directory, and desired npm version
ARG NODE_VERSION=18.0.0
ARG NPM_VERSION=7.24.0
ENV NVM_DIR /usr/local/nvm

RUN apk --no-cache add bash curl git jq py3-pip python3 && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | PROFILE=/dev/null bash

RUN . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    npm install -g npm@$NPM_VERSION

# Runtime Stage
FROM alpine:3.18

COPY --from=builder /usr/local/nvm $NVM_DIR

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN apk --no-cache add docker && \
    curl -o go.tar.gz https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz && \
    rm -rf /var/cache/apk/*

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy your entrypoint
COPY entrypoint.sh ./

ENTRYPOINT ["/app/entrypoint.sh"]
