FROM debian:bullseye-slim

ENV ACTIVATION_CODE Code
ENV LOCATION smart
ENV PREFERRED_PROTOCOL auto
ENV LIGHTWAY_CIPHER auto

ARG APP=expressvpn_3.52.0.2-1_amd64.deb

RUN mkdir /config \
    && mkdir /watch \
    && mkdir /downloads \
    && mkdir /incomplete

RUN apt-get update && apt-get install -y --no-install-recommends \
    libterm-readkey-perl ca-certificates wget expect iproute2 curl procps libnm0 transmission-daemon \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q "https://www.expressvpn.works/clients/linux/${APP}" -O /tmp/${APP} \
    && dpkg -i /tmp/${APP} \
    && rm -rf /tmp/*.deb \
    && apt-get purge -y --auto-remove wget

ENV T_ALLOWED=*.*.*.*
ENV T_USERNAME=admin
ENV T_PASSWORD=admin
ENV T_PORT=9001

COPY entrypoint.sh /tmp/entrypoint.sh
COPY expressvpnActivate.sh /tmp/expressvpnActivate.sh

ENTRYPOINT ["/bin/bash", "/tmp/entrypoint.sh"]
