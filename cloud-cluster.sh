source .env.sh

curl -s -XPOST "https://api.elastic-cloud.com/api/v1/deployments?validate_only=false&request_id=$ALIAS-demo" \
  -H "Authorization: ApiKey $EC_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '
{
  "name": "$ALIAS",
  "resources": {
    "elasticsearch": [
      {
        "region": "gcp-europe-west1",
        "plan": {
          "cluster_topology": [
            {
              "zone_count": 1,
              "elasticsearch": { },
              "instance_configuration_id": "gcp.es.datahot.n2.68x32x45",
              "node_roles": [
                "master",
                "ingest",
                "transform",
                "data_hot",
                "remote_cluster_client",
                "data_content"
              ],
              "id": "hot_content",
              "size": {
                "value": 2048,
                "resource": "memory"
              }
            }
          ],
          "elasticsearch": {
            "version": "$STACK_VERSION",
            "enabled_built_in_plugins": []
          },
          "deployment_template": {
            "id": "gcp-cpu-optimized-v3"
          }
        },
        "ref_id": "main-elasticsearch"
      }
    ],
    "kibana": [
      {
        "elasticsearch_cluster_ref_id": "main-elasticsearch",
        "region": "gcp-europe-west1",
        "plan": {
          "cluster_topology": [
            {
              "instance_configuration_id": "gcp.kibana.n2.68x32x45",
              "zone_count": 1,
              "size": {
                "resource": "memory",
                "value": 1024
              }
            }
          ],
          "kibana": {
            "version": "$STACK_VERSION"
          }
        },
        "ref_id": "main-kibana"
      }
    ]
  },
  "settings": {
    "autoscaling_enabled": false
  }
}' | jq


