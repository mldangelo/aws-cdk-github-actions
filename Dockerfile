FROM alpine:3.18

# Allow Node version to be specified at build time
ARG NODE_VERSION=18

RUN apk --update --no-cache add \
    nodejs=${NODE_VERSION} \
	npm \
	python3 \
	py3-pip \
	jq \
	curl \
	bash \
	git \
	docker \
	&& ln -sf /usr/bin/python3 /usr/bin/python

COPY --from=golang:alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY entrypoint.sh ./

ENTRYPOINT ["/app/entrypoint.sh"]
