FROM debian:12.7-slim AS base

RUN apt update -y
RUN apt install -y libpcre3 libedit2 libpcap0.8 libvdeplug2

FROM base AS build

RUN apt install -y build-essential git cmake cmake-data sudo
RUN apt install -y pkg-config libpcre3-dev libedit-dev libpcap-dev libvdeplug-dev

WORKDIR /usr/src
RUN git clone https://github.com/open-simh/simh.git

WORKDIR /usr/src/simh
RUN git checkout 36605c4950faf0c3a01f3d24040dfb5519bc0ae3
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo

FROM base

RUN mkdir -p /opt/pdp11
WORKDIR /opt/pdp11

COPY unix-v6.tap .
#COPY bsd.tap unix-v6.tap
COPY simh.ini .

COPY --from=build /usr/src/simh/BIN/pdp11 .

CMD ["./pdp11"]
