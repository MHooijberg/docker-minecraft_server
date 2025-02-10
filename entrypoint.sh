#!/usr/bin/env sh

START_COMMAND="java -Duser.language=en_US -XX:+UnlockExperimentalVMOptions -XX:+UseContainerSupport -XX:MaxRAMPercentage=100.0 -XX:+UseG1GC -jar $SERVER_DIR/server.jar nogui";
NO_JAR_FILE=$([ ! -f "$SERVER_DIR/server.jar" ] && echo true || echo false);

# Move latest server.jar to ensure latest server.jar is always used.
mv /tmp/server.jar $SERVER_DIR/server.jar;
# Ensure correct permissions for execution are set on the file.
chmod 744 $SERVER_DIR/server.jar;

# If the server.jar does not exist yet, execute the following.
if $NO_JAR_FILE; then
    # First run to populate the server folder
    $START_COMMAND;

    # Accept nececarry files
    sed -i 's|eula=false|eula=true|' $SERVER_DIR/eula.txt;

    # Get the list of all files in /opt/plugins (excluding directories)
    PLUGINS=($(find "$SRC_DIR/plugins" -maxdepth 1 -type f -exec basename {} \;));

    # Move plugins to server plugins directory if they are not already there
    for PLUGIN in "${PLUGINS[@]}"; do
        if [ ! -f "$SERVER_DIR/plugins/$PLUGIN" ] && [ -f "$SRC_DIR/plugins/$PLUGIN" ]; then
            mkdir -p "$SERVER_DIR/plugins/";
            mv "$SRC_DIR/plugins/$PLUGIN" "$SERVER_DIR/plugins/";
        fi
    done
    rm -rf /tmp/plugins;
fi

$START_COMMAND;