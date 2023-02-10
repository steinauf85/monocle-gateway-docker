# *********************************************************************
#             __  __  ___  _  _  ___   ___ _    ___
#            |  \/  |/ _ \| \| |/ _ \ / __| |  | __|
#            | |\/| | (_) | .` | (_) | (__| |__| _|
#            |_|  |_|\___/|_|\_|\___/ \___|____|___|
#
# -------------------------------------------------------------------
#                    MONOCLE GATEWAY SERVICE
# -------------------------------------------------------------------
#
#  The Monocle Gateway Service is a small service that you install
#  and run inside your network to order to facilitate communication
#  between the Monocle (cloud) platform and your IP cameras. 
#
# -------------------------------------------------------------------
#        COPYRIGHT SHADEBLUE, LLC @ 2019, ALL RIGHTS RESERVED
# -------------------------------------------------------------------
# 
# *********************************************************************

# ---------------------------------------------------
# Start with the base Debian:Buster-slim Linux image
# ---------------------------------------------------
FROM debian:buster-slim
WORKDIR /root

# ---------------------------------------
# Monocle Gateway image arguments.
# ---------------------------------------
ARG BUILD_VERSION=v0.0.4

# ---------------------------------------
# Monocle Gateway image labels.
# ---------------------------------------
LABEL name="Monocle Gateway"
LABEL url="https://monoclecam.com"
LABEL image="monoclecam/rpi-monocle-gateway"
LABEL description="This image provides a Docker container for the Monocle Gateway service based on Debian:Buster-slim Linux."
LABEL version=$BUILD_VERSION

# ---------------------------------------
# Install Monocle Gateway dependencies
# ---------------------------------------
RUN apt update && apt install -y \
    libcap2-bin                  \    
    wget

# ---------------------------------------
# Download versioned Monocle Gateway
# build archive file
# - - - - - - - - - - - - - - - - - - - -
# Extract Moncole Gateway related 
# executables to the appropriate 
# runtime directories 
# - - - - - - - - - - - - - - - - - - - -
# Remove the downloaded Monocle Gateway 
# archive files
# ---------------------------------------
RUN wget -c https://files.monoclecam.com/monocle-gateway/raspberrypi/monocle-gateway-linux-raspi-$BUILD_VERSION.tar.gz -O monocle-gateway.tar.gz && \
    cd /usr/local/bin/ && \
    tar xvzf /root/monocle-gateway.tar.gz monocle-gateway && \ 
    tar xvzf /root/monocle-gateway.tar.gz monocle-proxy  && \
    rm /root/monocle-gateway.tar.gz

# ---------------------------------------
# Expose required TCP ports 
# (port 443 is required by Amazon for 
# secure connectivity)
# ---------------------------------------
EXPOSE 443/tcp

# ---------------------------------------
# Expose required UDP ports 
# (used for the @proxy method to allow 
# IP cameras to transmit streams via UDP)
# ---------------------------------------
EXPOSE 62000-62100/udp

# ---------------------------------------
# Launch the Monocle Gateway executable 
# (on container startup)
# ---------------------------------------
CMD [ "monocle-gateway" ]
