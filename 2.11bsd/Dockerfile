# hadolint global ignore=DL3008

####################
# Build DEC PDP11 on Open SimH
FROM debian:12.10-slim AS build-pdp11

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential cmake cmake-data \
        libedit2 libedit-dev libpcre3 libpcre3-dev pkg-config zlib1g zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/simh

ADD https://github.com/open-simh/simh.git#36605c4950faf0c3a01f3d24040dfb5519bc0ae3 .

RUN cmake/cmake-builder.sh --flavor unix --target pdp11 --novideo --notest \
    && mkdir -p /opt/pdp11 \
    && cp BIN/pdp11 /opt/pdp11/

####################
# DEC PDP11 on Open SimH
FROM gcr.io/distroless/base-nossl-debian12:nonroot AS pdp11

WORKDIR /opt/pdp11

COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libpcre.so.3 /lib/x86_64-linux-gnu/
COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libedit.so.2 /lib/x86_64-linux-gnu/
COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libtinfo.so.6 /lib/x86_64-linux-gnu/
COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libbsd.so.0 /lib/x86_64-linux-gnu/
COPY --from=build-pdp11 /lib/x86_64-linux-gnu/libmd.so.0 /lib/x86_64-linux-gnu/

COPY --from=build-pdp11 /usr/src/simh/BIN/pdp11 .

ENTRYPOINT ["./pdp11"]

####################
# Build DEC PDP11 with 2.11BSD on Open SimH
FROM build-pdp11 AS build-pdp11-2.11bsd

WORKDIR /opt/pdp11

ADD https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/2.11BSD-481-simh-dist.tap 2.11bsd.tap
ADD https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD/Patches/482 482.txt

COPY data/Makefile.patch data/
COPY data/SIMH data/
COPY data/fstab data/
COPY data/rc.patch data/

RUN sed -n '89,182p' < 482.txt > data/482.sh \
    && sed -n '205,$p' < 482.txt > data/482.patch \
    && chmod a+x data/482.sh \
    && tar cvf data.tar data

COPY simh/install-tape.ini .
RUN ["./pdp11", "install-tape.ini"]

COPY simh/install-file-system.ini .
RUN ["./pdp11", "install-file-system.ini"]

COPY simh/install-rebuild.ini .
RUN ["./pdp11", "install-rebuild.ini"]

COPY simh/install-config.ini .
RUN ["./pdp11", "install-config.ini"]

####################
# DEC PDP11 with 2.11BSD on Open SimH
FROM pdp11 AS pdp11-2.11bsd

WORKDIR /opt/pdp11

COPY simh/run-pdp11.ini .
COPY --chown=nonroot:nonroot --from=build-pdp11-2.11bsd /opt/pdp11/rq0.dsk .

ENTRYPOINT ["./pdp11", "run-pdp11.ini"]

####################
# Build DEC PDP11 with 2.11BSD and httpd on Open SimH
FROM build-pdp11-2.11bsd AS build-pdp11-2.11bsd-httpd

RUN apt-get update \
    && apt-get install -y --no-install-recommends busybox \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /bin/busybox /usr/bin/wget

WORKDIR /opt/pdp11

ADD https://github.com/AaronJackson/2.11BSDhttpd.git#6ee71e5ed2a462f492543b372df3d631d70afd26 data/httpd
COPY data/index.html data/

RUN tar cvf data.tar data

COPY simh/install-httpd.ini .
RUN ["./pdp11", "install-httpd.ini"]

####################
# DEC PDP11 with 2.11BSD and httpd on Open SimH
FROM pdp11 AS pdp11-2.11bsd-httpd

EXPOSE 80/tcp

COPY --from=build-pdp11-2.11bsd-httpd /bin/busybox /bin/busybox
COPY --from=build-pdp11-2.11bsd-httpd /usr/bin/wget /usr/bin/wget

HEALTHCHECK --interval=30s --timeout=3s \
    CMD ["/usr/bin/wget", "--no-verbose", "--tries=1", "--spider", "http://127.0.0.1/"]

WORKDIR /opt/pdp11

COPY simh/run-pdp11-httpd.ini .
COPY --chown=nonroot:nonroot --from=build-pdp11-2.11bsd-httpd /opt/pdp11/rq0.dsk .

ENTRYPOINT ["./pdp11", "run-pdp11-httpd.ini"]
