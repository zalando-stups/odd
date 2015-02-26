#!/bin/bash

REV=$(git rev-parse HEAD)
URL=$(git config --get remote.origin.url)
STATUS=$(git status --porcelain)

if [ -n "$STATUS" ]; then
    REV="$REV (locally modified)"
fi

echo '{"url": "git:'$URL'", "revision": "'$REV'", "author": "'$USER'", "status": "'$STATUS'"}' > scm-source.json
docker build -t bastion-host .
