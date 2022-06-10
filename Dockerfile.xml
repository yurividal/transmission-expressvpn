FROM debian:bullseye-slim

ENV ACTIVATION_CODE Code
ENV LOCATION smart
ENV PREFERRED_PROTOCOL auto
ENV LIGHTWAY_CIPHER auto

ARG APP=expressvpn_3.25.0.13-1_armhf.deb

RUN dpkg --add-architecture armhf

RUN mkdir /config \
    && mkdir /watch \
    && mkdir /downloads \
    && mkdir /incomplete

RUN apt-get update && apt-get install -y --no-install-recommends \
    libterm-readkey-perl ca-certificates wget expect iproute2 curl procps libnm0 libc6:armhf libstdc++6:armhf transmission-daemon \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q "https://www.expressvpn.works/clients/linux/${APP}" -O /tmp/${APP} \
    && dpkg -i /tmp/${APP} \
    && rm -rf /tmp/*.deb \
    && apt-get purge -y --auto-remove wget

RUN cd /lib \
    ln -s arm-linux-gnueabihf/ld-2.23.so ld-linux.so.3


ENV T_ALLOWED=*.*.*.*
ENV T_USERNAME=admin
ENV T_PASSWORD=admin
ENV T_PORT=9001

COPY entrypoint.sh /tmp/entrypoint.sh
COPY expressvpnActivate.sh /tmp/expressvpnActivate.sh

ENTRYPOINT ["/bin/bash", "/tmp/entrypoint.sh"]
