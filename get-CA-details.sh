#!/usr/bin/bash

docker cp es-cluster-es01-1:/usr/share/elasticsearch/config/certs/ca/ca.crt /tmp/.
#cat /tmp/ca.crt
echo 'ssl:';
echo '  certificate_authorities:';
echo '  - |';
cat /tmp/ca.crt | sed 's/^/    /'
echo ''
echo 'Cerft Fingerprint:'
openssl x509 -fingerprint -sha256 -noout -in /tmp/ca.crt | awk -F"=" {' print $2 '} | sed s/://g
