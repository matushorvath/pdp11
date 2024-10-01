FROM debian:12.7-slim

RUN apt update -y
RUN apt install -y build-essential git cmake cmake-data sudo
RUN apt install -y pkg-config libpcre3-dev libedit-dev libpcap-dev libvdeplug-dev

WORKDIR /usr/src
RUN git clone https://github.com/open-simh/simh.git

WORKDIR /usr/src/simh
RUN git checkout 36605c4950faf0c3a01f3d24040dfb5519bc0ae3
RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo

# TODO remove the sources, keep just the pdp11 binary, perhaps install it

WORKDIR /usr/src/simh/BIN

COPY Unix-v6-Ken-Wellsch.tap unix-v6.tap
COPY simh.ini .

CMD ["./pdp11", "simh.ini"]
