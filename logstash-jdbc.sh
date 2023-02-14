source .env.sh

# Running on Cloud
time docker run \
  --name=logstash \
  --rm -it \
  -v $(pwd)/logstash-config-jdbc/pipeline/:/usr/share/logstash/pipeline/ \
  -v $(pwd)/logstash-config-jdbc/lib/:/tmp/lib/ \
  -e XPACK_MONITORING_ENABLED=false \
  -e LOG_LEVEL=info \
  -e ELASTICSEARCH_URL="$ELASTICSEARCH_URL" \
  -e ELASTIC_PASSWORD="$ELASTIC_PASSWORD" \
  -e STACK_VERSION="$STACK_VERSION" \
  docker.elastic.co/logstash/logstash:$STACK_VERSION
