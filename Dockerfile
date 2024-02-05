FROM alpine:3.19

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
			org.label-schema.name="docker-helm" \
			org.label-schema.description="Alpine Helm 3 image with helm-schema-gen plugin." \
			org.label-schema.url="http://andradaprieto.es" \
			org.label-schema.vcs-ref=$VCS_REF \
			org.label-schema.vcs-url="https://github.com/jandradap/docker-helm" \
			org.label-schema.vendor="Jorge Andrada Prieto" \
			maintainer="Jorge Andrada Prieto <jandradap@gmail.com>"

ENV VERSION=3.14.0

# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${VERSION}-linux-amd64.tar.gz"

RUN apk add --update --no-cache --clean-protected \
    curl \
    ca-certificates \
    git \
    && curl -L ${BASE_URL}/${TAR_FILE} |tar xvz \
    && mv linux-amd64/helm /usr/bin/helm \
    && chmod +x /usr/bin/helm \
    && rm -rf linux-amd64 \
    && helm plugin install https://github.com/karuppiah7890/helm-schema-gen \
    && apk del curl \
    && rm -f /var/cache/apk/*

WORKDIR /apps

ENTRYPOINT ["helm"]

CMD ["--help"]