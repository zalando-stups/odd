#!/bin/bash
set -euo pipefail

VERSION="1.1.11"
DOWNLOAD_URL="https://github.com/aws/aws-ec2-instance-connect-config/archive/${VERSION}.tar.gz"

curl -L -o instance-connect.tar.gz "${DOWNLOAD_URL}"
TEMP_DIR=$(mktemp -d)
tar xzf instance-connect.tar.gz -C "$TEMP_DIR"

for file in ${TEMP_DIR}/aws-ec2-instance-connect-config-${VERSION}/src/bin/eic_* ; do
    chmod +x $file
    mv $file /usr/local/bin/
done

rm -rf "${TEMP_DIR}"
