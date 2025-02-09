#!/usr/bin/env sh

LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/${TYPE_PROJECT}/versions/${VERSION_MINECRAFT}/builds | \
    jq -r '.builds | map(select(.channel == "default") | .build) | .[-1]')

if [ "$LATEST_BUILD" != "null" ]; then
    JAR_NAME=${TYPE_PROJECT}-${VERSION_MINECRAFT}-${LATEST_BUILD}.jar
    PAPERMC_URL="https://api.papermc.io/v2/projects/${TYPE_PROJECT}/versions/${VERSION_MINECRAFT}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}"

    # Download the latest Paper version
    wget -O /opt/server.jar $PAPERMC_URL
    echo "Download completed"
    exit 0
else
    echo "No stable build for version $VERSION_MINECRAFT found."
    exit 1
fi