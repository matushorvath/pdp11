2.11BSD Tape
============

https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/  
https://github.com/eunuchs/unix-archive/blob/master/PDP-11/Documentation/PUPS_Html/Setup/2.11bsd_setup.txt  

Swap panic
==========

https://www.retro11.de/ouxr/211bsd/usr/src/sys/sys/init_main.c.html  

Open SimH Boot
==============

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

New Structure
=============

pdp11:<sha>
pdp11:v1
pdp11:latest

pdp11-unix-v6:<sha>
pdp11-unix-v6:v1
pdp11-unix-v6:latest

pdp11-2.11bsd:<sha>
pdp11-2.11bsd:patch-482.v1
pdp11-2.11bsd:patch-482
pdp11-2.11bsd:latest

pdp11-2.11bsd-httpd:<sha>
pdp11-2.11bsd-httpd:patch-482.v1
pdp11-2.11bsd-httpd:patch-482
pdp11-2.11bsd-httpd:latest

pdp11-2.11bsd-gcc:<sha>
pdp11-2.11bsd-gcc:patch-482.v1
pdp11-2.11bsd-gcc:patch-482
pdp11-2.11bsd-gcc:latest

Patch Failures
==============

```
#59 19.05 # patch -p0 < /tmp/data/482.patch
...
#59 19.73 |*** ./usr/src/sbin/dump/dump.h.old     Tue Dec  6 23:48:31 1994
#59 19.73 |--- ./usr/src/sbin/dump/dump.h Wed Sep 18 19:11:17 2024
#59 19.73 --------------------------
#59 19.75 Patching file ./usr/src/sbin/dump/dump.h using Plan A...
#59 19.75 Hunk #1 succeeded at 1.
#59 19.76 Hunk #2 failed at 80.
#59 19.80 1 out of 2 hunks failed--saving rejects to ./usr/src/sbin/dump/dump.h#
```

```
#59 52.26 # patch -p0 < /tmp/data/494.patch
#59 52.36 Hmm...  Looks like a new-style context diff to me...
#59 52.38 The text leading up to this was:
#59 52.38 --------------------------
#59 52.38 |*** ./usr/src/sys/pdpuba/dz.c.old      Tue Aug 12 18:39:14 2025
#59 52.39 |--- ./usr/src/sys/pdpuba/dz.c  Wed Aug 13 06:07:16 2025
#59 52.39 --------------------------
#59 52.42 Patching file ./usr/src/sys/pdpuba/dz.c using Plan A...
#59 52.46 Hunk #1 failed at 3.
#59 52.47 Hunk #2 failed at 373.
#59 52.62 2 out of 2 hunks failed--saving rejects to ./usr/src/sys/pdpuba/dz.c#
```

One of the patches suggests we rebuild the kernel.
Multiple errors reported during userspace builds, but some may be expected.
