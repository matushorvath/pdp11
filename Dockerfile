FROM debian:12.7-slim

RUN apt update
RUN apt install -y simh

WORKDIR /usr/src/pdp11
COPY Unix-v6-Ken-Wellsch.tap unix-v6.tap
COPY tboot.ini .
COPY dboot.ini .

CMD ["pdp11", "tboot.ini"]
