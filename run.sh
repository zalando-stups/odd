#!/bin/bash

if [ -z "$GRANTING_SERVICE_SSH_KEYS" ]; then
    echo 'GRANTING_SERVICE_SSH_KEYS must be set'
    exit 1
fi

if [ -z "$GRANTING_SERVICE_URL" ]; then
    echo 'GRANTING_SERVICE_URL must be set'
    exit 1
fi

echo 'ssh_access_granting_service_url: "'$GRANTING_SERVICE_URL'"' > /etc/ssh-access-granting-service.yaml
echo 'allowed_remote_networks: ['$ALLOWED_REMOTE_NETWORKS']' >> /etc/ssh-access-granting-service.yaml

echo 'Writing SSH public key..'
echo "$GRANTING_SERVICE_SSH_KEYS" | sed 's/^/command="grant-ssh-access-forced-command.py" /' > ~granting-service/.ssh/authorized_keys

echo 'Starting Supervisor..'
/usr/bin/supervisord -c /etc/supervisord.conf
