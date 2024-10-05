2.11BSD Tape
============

https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/  
https://github.com/eunuchs/unix-archive/blob/master/PDP-11/Documentation/PUPS_Html/Setup/2.11bsd_setup.txt  

Swap panic
==========

https://www.retro11.de/ouxr/211bsd/usr/src/sys/sys/init_main.c.html  

SIMH Boot
=========

http://www.vaxman.de/publications/bsd211_inst.pdf  

Misc
====
https://raw.githubusercontent.com/bsdimp/mk211bsd/master/195/mk211p195tape.pl  
http://bsdimp.blogspot.com/2020/07/simh-setup-for-211bsd-restoration.html  
https://gunkies.org/wiki/2.11BSD  
https://groups.google.com/g/pidp-11/c/K99hzmAMkic  
https://manpath.be/bsd211  
https://www.retrocmp.com/how-tos/installing-211bsd-unix-on-pdp-1144

TODO
====

- hostname and domain as input parameters
- timezone as input parameter
- root password as input parameter, or generated and exposed
- USER not root
- HEALTHCHECK for httpd
- use alpine as base image

Networking
==========

NAT args:
NAT network setup:
        gateway       =10.0.2.2/24(255.255.255.0)
        DNS           =10.0.2.3
        dhcp_start    =10.0.2.15

ATTACH XQ NAT:tcp=2323:10.0.2.15:23,tcp=2121:10.0.2.15:21

set xq enabled
attach xq0 nat:gateway=10.0.0.1/24,dns=10.0.0.2/24

show xq
show xq eth

ifconfig qe0 inet netmask 255.255.255.0 10.0.2.100 broadcast 127.255.255.255 up -trailers
route delete default 127.0.0.1
route add default 10.0.2.2 1
netstat -rn

Telnet
======

docker run -p 2121:21/tcp matushorvath/2.11bsd
telnet localhost 2121
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Connection closed by foreign host.

(probably set up ptys?)
