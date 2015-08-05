#!/bin/ash
set -e

if [ "$1" = 'consul-template' ]; then
    CONSUL_CONNECT=${CONSUL_CONNECT:-consul.service.consul:8500}

    chown -R haproxy:haproxy .
    shift
    exec gosu haproxy consul-template \
         -config=/data/consul-template/config.d \
         -consul=${CONSUL_CONNECT} "$@"
fi

exec "$@"
