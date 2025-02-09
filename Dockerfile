# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# 1. Download required dependencies.
# 2. Setup server.
# 3. Run application

# TODO: 2025-02-09 15:27:21 [14:27:21 WARN]: [oshi.software.os.linux.LinuxOperatingSystem] Did not find udev library in operating system. Some features may not work.
# TODO: Implement java user.
# TODO: Add volume for persistent data.

ARG VERSION_MINECRAFT="1.21.4"
ARG VERSION_OPENJDK="21"
ARG TYPE_PROJECT="paper"

#####################
# Stage: Packages   #
#####################
FROM amazoncorretto:${VERSION_OPENJDK} AS packages

# Ensure global arguments can be used within the scope of this stage.
ARG TYPE_PROJECT
ARG VERSION_MINECRAFT

# Export Docker arguments into the container.
ENV TYPE_PROJECT=${TYPE_PROJECT}
ENV VERSION_MINECRAFT=${VERSION_MINECRAFT}

COPY get_papermc_jar.sh /opt/get_papermc_jar.sh

RUN yum install -y jq wget && \
    /opt/get_papermc_jar.sh;


#####################
# Stage: Production #
#####################
FROM amazoncorretto:${VERSION_OPENJDK} AS production

# Ensure global arguments can be used within the scope of this stage.
ARG TYPE_PROJECT
ARG VERSION_MINECRAFT

# Export Docker arguments into the container.
ENV TYPE_PROJECT=${TYPE_PROJECT}
ENV VERSION_MINECRAFT=${VERSION_MINECRAFT}

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     app-data
# USER app-data

# RUN mkdir /opt/${TYPE_PROJECT}_${VERSION_MINECRAFT}_server
WORKDIR /opt/${TYPE_PROJECT}_${VERSION_MINECRAFT}_server

COPY --chown=app-data:app-data --from=packages /opt/server.jar /opt/${TYPE_PROJECT}_${VERSION_MINECRAFT}_server/server.jar

RUN chmod 744 /opt/${TYPE_PROJECT}_${VERSION_MINECRAFT}_server/server.jar && \
    java -jar /opt/${TYPE_PROJECT}_${VERSION_MINECRAFT}_server/server.jar nogui && \
    sed -i 's|eula=false|eula=true|' /opt/${TYPE_PROJECT}_${VERSION_MINECRAFT}_server/eula.txt;

EXPOSE 25565
ENTRYPOINT ["/bin/sh", "-c", "java -Duser.language=en_US -Xmx3584M -jar /opt/${TYPE_PROJECT}_${VERSION_MINECRAFT}_server/server.jar nogui;"]
