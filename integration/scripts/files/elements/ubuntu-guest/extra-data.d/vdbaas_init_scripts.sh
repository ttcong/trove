#!/bin/bash
metadata_url="http://169.254.169.254/openstack/latest/network_data.json"
exitcode=0
# 1. Change SSHD ListenAddress to Private IP only
internal_ip=$(curl -s $metadata_url | jq -r '.networks[1].ip_address')
if [[ -n "$internal_ip" ]]; then
  sed -i '/^ListenAddress/d' /etc/ssh/sshd_config
  echo "ListenAddress $internal_ip" >> /etc/ssh/sshd_config
  systemctl restart ssh
else
  exitcode=1
fi 

# 2. Run monasca-setup (monasca-agent) if cloud-init succeced
cmd="/usr/bin/cloud-init status --wait"
$cmd
status=$?
if [[ $status -eq 0 ]]; then
  username="dbaas-monitor"
  password="Munyr=+>!&38"
  keystone_url="http://10.10.18.240:5000/v3"
  monasca_url="http://10.10.18.240:8070/v2.0"
  check_frequency=60
  monasca_statsd_interval=60

  # Setup Monasca-Agent base config and system metrics
  /usr/local/bin/monasca-setup --username $username \
  --password $password \
  --project_name "dbaas" \
  --project_domain_name "default" \
  --user_domain_name "default" \
  --service_type "monitoring" \
  --keystone_url $keystone_url \
  --monasca_url $monasca_url \
  --check_frequency $check_frequency \
  --monasca_statsd_interval $monasca_statsd_interval \
  --system_only

  exitcode=$(( $exitcode || $? ))

  # Setup Monasca-Agent for database services. 
  # Fixme: postgresql, mongo, redis.
  /usr/local/bin/monasca-setup --username $username \
  --password $password \
  --project_name "dbaas" \
  --project_domain_name "default" \
  --user_domain_name "default" \
  --service_type "monitoring" \
  --keystone_url $keystone_url \
  --monasca_url $monasca_url \
  --check_frequency $check_frequency \
  --monasca_statsd_interval $monasca_statsd_interval \
  --detection_plugins mysql
  
  exitcode=$(( $exitcode || $? ))
else 
  exitcode=1
fi

exit $exitcode
