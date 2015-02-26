#!/bin/bash

if [ -z "$SSH_KEY" ]; then
    echo "SSH_KEY must be set"
    exit 1
fi

cat Dockerfile.template | envsubst > Dockerfile
docker build -t bastion-host .
