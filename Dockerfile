FROM sisk/haproxy:latest

MAINTAINER Jean-Charles Sisk <jeancharles@paypal.com>

ENV CONSUL_TEMPLATE_VERSION=0.10.0

RUN apk --update add ca-certificates \
    && rm -rf /var/cache/apk/*

RUN ARCH=$(ARCH=$(apk --print-arch); case $ARCH in x86_64)ARCH=amd64;; x86)ARCH=386;; esac; echo $ARCH) \
    && wget -qO- https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_${ARCH}.tar.gz | tar xzO consul-template_${CONSUL_TEMPLATE_VERSION}_linux_${ARCH}/consul-template > /usr/local/bin/consul-template \
    && chmod +x /usr/local/bin/consul-template

RUN mkdir -p /data/consul-template/config.d /data/consul-template/template.d

COPY config/ /data/consul-template/config.d/
COPY templates/ /data/consul-template/template.d/

RUN chown -R haproxy:haproxy /data/consul-template

COPY entrypoint.sh /consul-template-entrypoint.sh

RUN chmod +x /consul-template-entrypoint.sh
ENTRYPOINT ["/consul-template-entrypoint.sh"]

WORKDIR /data/consul-template

CMD ["consul-template"]
