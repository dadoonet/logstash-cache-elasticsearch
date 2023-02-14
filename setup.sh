source .env.sh

JDBC_JAR=x-pack-sql-jdbc-$STACK_VERSION.jar

# Utility functions
check_service () {
	echo -ne '\n'
	echo $1 $STACK_VERSION must be available on $2
	echo -ne "Waiting for $1"

	until curl -u elastic:$ELASTIC_PASSWORD -s "$2" | grep "$3" > /dev/null; do
		  sleep 1
			echo -ne '.'
	done

	echo -ne '\n'
	echo $1 is now up.
}

# Start of the script
echo Installation script for LOGSTASH CACHE ELASTICSEARCH demo with Elastic $STACK_VERSION

echo "##################"
echo "### Pre-checks ###"
echo "##################"

echo Pull logstash $STACK_VERSION docker image
docker pull docker.elastic.co/logstash/logstash:$STACK_VERSION


if [ ! -e logstash-config/lib/$JDBC_JAR ] ; then
	echo "Downloading $JDBC_JAR"
	rm -rf logstash-config-jdbc/lib
	mkdir -p logstash-config-jdbc/lib
	cd logstash-config-jdbc/lib
	wget https://artifacts.elastic.co/maven/org/elasticsearch/plugin/x-pack-sql-jdbc/$STACK_VERSION/$JDBC_JAR
	cd -
fi

check_service "Elasticsearch" "$ELASTICSEARCH_URL" "\"number\" : \"$STACK_VERSION\""
check_service "Kibana" "$KIBANA_URL/app/home#/" "<title>Elastic</title>"

echo -ne '\n'
echo "################################"
echo "### Configure Cloud Services ###"
echo "################################"
echo -ne '\n'

echo "Removing the VIP index"
curl -s -XDELETE -u elastic:$ELASTIC_PASSWORD -s "$ELASTICSEARCH_URL/vip" 2>/dev/null | jq
echo "Create the VIP index"
curl -s -XPUT "$ELASTICSEARCH_URL/vip" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -d'@elasticsearch-config/vip-index.json' 2>/dev/null | jq
curl -s -XPOST "$ELASTICSEARCH_URL/vip/_bulk" -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/x-ndjson' --data-binary @elasticsearch-config/vip-data.ndjson >/dev/null 2>/dev/null


echo -ne '\n'
echo "#####################"
echo "### Demo is ready ###"
echo "#####################"
echo -ne '\n'

echo "Install Sample web logs from Kibana"
echo "open https://$KIBANA_URL/app/home#/tutorial_directory/sampleData"

