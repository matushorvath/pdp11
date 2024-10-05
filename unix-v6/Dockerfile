####################
# Base image
FROM debian:12.7-slim AS base

RUN <<EOT
    apt-get update
    apt-get install -y --no-install-recommends libpcre3 libedit2 libpcap0.8 libvdeplug2
    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOT

####################
# Build open-simh
FROM base AS build-simh

RUN <<EOT
    apt-get update
    apt-get install -y --no-install-recommends build-essential cmake cmake-data sudo \
        pkg-config libpcre3-dev libedit-dev libpcap-dev libvdeplug-dev
    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOT

WORKDIR /usr/src/simh
ADD https://github.com/open-simh/simh.git#36605c4950faf0c3a01f3d24040dfb5519bc0ae3 .
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo

####################
# Run
FROM base

WORKDIR /opt/pdp11

COPY simh.ini .
ADD https://www.tuhs.org/Archive/Distributions/Other/OS_Course/v6/dist.tap .
COPY --from=build-simh /usr/src/simh/BIN/pdp11 .

CMD ["./pdp11"]
