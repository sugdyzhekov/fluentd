FROM fluent/fluentd:stable-onbuild
LABEL Maintainer="Sergey Ugdyzhekov, sergey@ugdyzhekov.org" Description="Fluentd docker image"

USER root

RUN mkdir /var/log/td-agent/ && chown fluent /var/log/td-agent/

RUN apk add --update --virtual .build-deps \
    sudo build-base ruby-dev \
    && sudo -u fluent gem install \
        fluent-plugin-secure-forward \
        fluent-plugin-elasticsearch \
        fluent-plugin-kinesis \
        fluent-plugin-s3 \
        fluent-plugin-influxdb --no-document \
        bigdecimal \
    && sudo -u fluent gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
        /home/fluent/.gem/ruby/2.3.0/cache/*.gem

USER fluent

EXPOSE 24284
