####################
# Base image
FROM debian:12.7-slim AS base

RUN apt-get update \
    && apt-get install -y --no-install-recommends libedit2 libpcap0.8 libpcre3 libvdeplug2 zlib1g \
    && rm -rf /var/lib/apt/lists/*

####################
# Build Open SimH
FROM base AS build-simh

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential cmake cmake-data \
        libedit-dev libpcap-dev libpcre3-dev libvdeplug-dev pkg-config zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/simh
ADD https://github.com/open-simh/simh.git#36605c4950faf0c3a01f3d24040dfb5519bc0ae3 .
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo

####################
# Run
FROM base as run

WORKDIR /opt/pdp11

COPY simh.ini .
ADD https://www.tuhs.org/Archive/Distributions/Other/OS_Course/v6/dist.tap .
COPY --from=build-simh /usr/src/simh/BIN/pdp11 .

CMD ["./pdp11"]
