## Dockerfile
## https://docker.github.io/engine/reference/builder/

## https://github.com/fooger/elasticsearch-analysis-morphology
## ATM Plugin available only for Elasticsearch 7.6.0;
FROM gradle:6.8.0-jdk15 AS gradle-builder

## Reuse prebuilt plugin
ADD https://github.com/fooger/elasticsearch-analysis-morphology/archive/master.zip /tmp/master.zip
RUN set -eux; \
  unzip /tmp/master.zip -d /build

## Plugin is available only for Elasticsearch 7.6.0.
FROM elasticsearch:7.6.0

## Pick artifact from builder
COPY --from=gradle-builder /build/elasticsearch-analysis-morphology-master/analysis-morphology-7.6.0.zip /tmp/analysis-morphology-7.6.0.zip

## Install plugin
RUN set -eu; \
  /usr/share/elasticsearch/bin/elasticsearch-plugin install file:///tmp/analysis-morphology-7.6.0.zip \
  && rm -f /tmp/analysis-morphology-7.6.0.zip
