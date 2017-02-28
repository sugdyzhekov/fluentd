FROM fluent/fluentd:edge-onbuild
LABEL Maintainer="Sergey Ugdyzhekov, sergey@ugdyzhekov.org" Description="Fluentd docker image"

USER root

RUN mkdir /var/log/td-agent/ && chown fluent /var/log/td-agent/

RUN apk add --update --virtual .build-deps \
    sudo build-base ruby-dev \
    && sudo -u fluent gem install \
        fluent-plugin-secure-forward \
        fluent-plugin-elasticsearch \
        fluent-plugin-kinesis --no-document \
    && sudo -u fluent gem install \
        fluent-plugin-s3 -v 1.0.0.rc2 --no-document \
    && sudo -u fluent gem install \
        fluent-plugin-influxdb -v 1.0.0.rc1 --no-document \
    && sudo -u fluent gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
        /home/fluent/.gem/ruby/2.3.0/cache/*.gem

USER fluent

EXPOSE 24284
