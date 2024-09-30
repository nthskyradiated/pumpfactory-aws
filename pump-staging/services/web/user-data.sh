#!/bin/bash

cat > index.html <<EOF
<h1>pumpFactory web status</h1>
<p>Postgres address: ${postgresql_address}</p>
<p>Postgres port: ${postgresql_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &