#!/usr/bin/env bash
# NetHSM needs provisioning:
# - Admin user & password, Unlock password, set systemtime
# - Set unattended boot so NetHSM starts without interaction (without unlocking)
# - Operator user & pass, Metrics user & pass, Backup user & pass
# - Encryption password for backup files
# All vars below originate in /root/hsm_env_vars

if [ -f /root/hsm_env_vars ]; then
    . /root/hsm_env_vars
fi

STATE=''
while [[ ${STATE} == '' ]]; do
  STATE=$(curl $CURLOPTS $API/health/state | jq -r '.state')
  sleep 1
done;

if [[ ${STATE} == "Unprovisioned" ]]; then
  echo "$(date) Provisioning NetHSM"
  curl $CURLOPTS -X 'POST' "$API/provision" \
  -H 'accept: */*' -H 'Content-Type: application/json' \
  -d '{"unlockPassphrase": "'${UNLOCKPASS}'", "adminPassphrase": "'${ADMINPASS}'", "systemTime": "'$(date +%FT%TZ)'"}'
  curl $CURLOPTS --user "admin:${ADMINPASS}" -X 'PUT' "$API/config/unattended-boot" \
  -H 'accept: */*' -H 'Content-Type: application/json' \
  -d '{"status": "on"}'
  curl $CURLOPTS --user "admin:${ADMINPASS}" -X 'PUT' "$API/users/operator" \
  -H 'accept: */*' -H 'Content-Type: application/json' \
  -d '{"realName": "Nitrokey Operator", "role": "Operator", "passphrase": "'${OPERATORPASS}'"}'
  curl $CURLOPTS --user "admin:${ADMINPASS}" -X 'PUT' "$API/users/metrics" \
  -H 'accept: */*' -H 'Content-Type: application/json' \
  -d '{"realName": "Nitrokey Metrics", "role": "Metrics", "passphrase": "'${METRICSPASS}'"}'
  curl $CURLOPTS --user "admin:${ADMINPASS}" -X 'PUT' "$API/users/backup" \
  -H 'accept: */*' -H 'Content-Type: application/json' \
  -d '{"realName": "Nitrokey Backup", "role": "Backup", "passphrase": "'${BACKUPUSERPASS}'"}'
  curl $CURLOPTS --user "admin:${ADMINPASS}" -X 'PUT' "$API/config/backup-passphrase" \
  -H 'accept: */*' -H 'Content-Type: application/json' \
  -d '{"newPassphrase": "'${BACKUPPASS}'", "currentPassphrase": ""}'
  for X in {1..30}; do
    NS=ns${X}
    echo $NS
    curl $CURLOPTS --user "admin:$ADMINPASS" -X PUT $API/users/$NS~admin -H 'accept: */*' -H 'Content-Type: application/json' -d '{ "realName": "$NS_Admin", "role": "Administrator","passphrase": "'${PARTPASS_A}-${NS}'" }'
    curl $CURLOPTS --user "admin:$ADMINPASS" -X PUT $API/users/$NS~operator -H 'accept: */*' -H 'Content-Type: application/json' -d '{ "realName": "$NS_Operator", "role": "Operator","passphrase": "'${PARTPASS_O}-${NS}'" }'
    curl $CURLOPTS --user "admin:$ADMINPASS" -X PUT $API/namespaces/$NS -H 'accept: */*'
    curl $CURLOPTS --user "$NS~admin:$PARTPASS_A-$NS" -X GET $API/users -H 'accept: application/json' | jq .
    curl $CURLOPTS --user "$NS~operator:$PARTPASS_O-$NS" -X POST $API/random -H 'accept: application/json' -H 'Content-Type: application/json' -d '{ "length": 2 }' | jq -r .
  done
fi

STATE=$(curl $CURLOPTS $API/health/state | jq -r '.state')
echo "$(date) HSM state: ${STATE}"
