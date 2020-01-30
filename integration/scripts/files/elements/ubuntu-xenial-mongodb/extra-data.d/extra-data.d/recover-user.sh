#!/bin/bash
os_admin=$(jq '.username' /var/lib/trove/.os_mongo_admin_creds.json)
os_admin_pass=$(jq '.password' /var/lib/trove/.os_mongo_admin_creds.json)

sed -i 's/security.authorization: enabled/security.authorization: disabled/g' /etc/mongod.conf
sed -i 's/enableLocalhostAuthBypass: false/enableLocalhostAuthBypass: true/g' /etc/mongod.conf

systemctl restart mongod.service

cat >temp.js <<_EOF_
use admin;
db.dropUser($os_admin)
db.createUser({ user: $os_admin, pwd: $os_admin_pass, roles: [ "root" ] })
_EOF_

chown trove:trove temp.js

echo "Wait 10s for Mongod to restart"
sleep 10
/usr/bin/mongo < temp.js

sed -i 's/security.authorization: disabled/security.authorization: enabled/g' /etc/mongod.conf
sed -i 's/enableLocalhostAuthBypass: true/enableLocalhostAuthBypass: false/g' /etc/mongod.conf
systemctl restart mongod.service
