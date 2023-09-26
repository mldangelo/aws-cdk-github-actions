FROM alpine:3.18

# Allow Node version to be specified at build time
ARG NODE_VERSION=18

RUN apk --update --no-cache add \
	bash \
	curl \
	docker \
	git \
	jq \
	npm \
	py3-pip \
	python3 \
	nodejs=${NODE_VERSION} \
	&& ln -sf /usr/bin/python3 /usr/bin/python

COPY --from=golang:alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY entrypoint.sh ./

ENTRYPOINT ["/app/entrypoint.sh"]
