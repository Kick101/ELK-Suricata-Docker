#!/usr/bin/bash

KIBANA_URL="https://localhost:5601"
KIBANA_USER="elastic"
KIBANA_PASSWORD=${ELASTIC_PASSWORD}

POLICY_NAME="suricata-policy-1"
POLICY_DESCRIPTION="Fleet policy with Suricata integration created via curl."
POLICY_NAMESPACE="default"

# create policy for suricata
POLICY_ID=$(
curl -X POST -s -k "${KIBANA_URL}/api/fleet/agent_policies" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: xxx" \
  -u "${KIBANA_USER}:${KIBANA_PASSWORD}" \
  -d '{
        "name": "'"${POLICY_NAME}"'",
        "description": "'"${POLICY_DESCRIPTION}"'",
        "namespace": "'"${POLICY_NAMESPACE}"'"
      }' | grep -oE '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'
)

# Get enrollment token
TOKEN=$(curl -X GET -s -k "${KIBANA_URL}/api/fleet/enrollment_api_keys?kuery=policy_id:\"${POLICY_ID}\"" \
  -H "kbn-xsrf: xxx" \
  -u "${KIBANA_USER}:${KIBANA_PASSWORD}" \
  | jq -r '.items[] | select(.policy_id == "'"${POLICY_ID}"'") | .api_key'
)

echo "Policy ID:" $POLICY_ID
echo "Token:" $TOKEN
