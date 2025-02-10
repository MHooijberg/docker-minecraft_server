# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

ARG VERSION_MINECRAFT="1.21.4"
ARG VERSION_OPENJDK="21"
ARG TYPE_PROJECT="paper"
ARG SERVER_DIR="/opt/server"
ARG SRC_DIR="/tmp"

##########################
#    Stage: Packages     #
##########################
FROM amazoncorretto:${VERSION_OPENJDK} AS packages

# Ensure global arguments can be used within the scope of this stage.
ARG TYPE_PROJECT
ARG VERSION_MINECRAFT

# Export Docker arguments into the container.
ENV TYPE_PROJECT=${TYPE_PROJECT}
ENV VERSION_MINECRAFT=${VERSION_MINECRAFT}

COPY --chown=root:root get_papermc_jar.sh /opt/get_papermc_jar.sh

RUN yum install -y jq wget && \
    /bin/sh /opt/get_papermc_jar.sh;


##########################
# Stage: Production Base #
##########################
FROM amazoncorretto:${VERSION_OPENJDK} AS production_base

# Ensure global arguments can be used within the scope of this stage.
ARG TYPE_PROJECT
ARG VERSION_MINECRAFT
ARG SERVER_DIR
ARG SRC_DIR

# Export Docker arguments into the container.
ENV SERVER_DIR=${SERVER_DIR}
ENV SRC_DIR=${SRC_DIR}
ENV TERM=xterm-256color
ENV TYPE_PROJECT=${TYPE_PROJECT}
ENV VERSION_MINECRAFT=${VERSION_MINECRAFT}

RUN yum install -y udev

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
RUN adduser -M --shell "/sbin/nologin" app-data
USER app-data

COPY --chown=app-data:app-data --from=packages /opt/server.jar ${SRC_DIR}/server.jar
COPY --chown=app-data:app-data ./entrypoint.sh /entrypoint.sh

WORKDIR /opt/server

EXPOSE 25565
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]


##########################
# Stage: Production Plus #
##########################
FROM production_base AS production_plus

USER root

RUN yum install -y wget; \
    mkdir ${SRC_DIR}/plugins && \
    chown app-data:app-data ${SRC_DIR}/plugins;

USER app-data

RUN wget -P ${SRC_DIR}/plugins https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsX-2.20.1.jar && \
    wget -P ${SRC_DIR}/plugins https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsXChat-2.20.1.jar && \
    wget -P ${SRC_DIR}/plugins https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsXSpawn-2.20.1.jar && \
    wget -P ${SRC_DIR}/plugins https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsXDiscord-2.20.1.jar && \
    wget -P ${SRC_DIR}/plugins https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v5.5/bluemap-5.5-paper.jar;

EXPOSE 8100 25565