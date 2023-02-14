source .env.sh

# Running on Cloud
time docker run \
	--name=logstash \
	--rm -it \
	-v $(pwd)/logstash-config/pipeline/:/usr/share/logstash/pipeline/ \
	-e XPACK_MONITORING_ENABLED=false \
	-e ELASTICSEARCH_URL="$ELASTICSEARCH_URL" \
	-e ELASTIC_PASSWORD="$ELASTIC_PASSWORD" \
	-p 9600:9600 \
	docker.elastic.co/logstash/logstash:$STACK_VERSION
