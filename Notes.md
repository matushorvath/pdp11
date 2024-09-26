https://gunkies.org/wiki/Installing_UNIX_v6_(PDP-11)_on_SIMH
http://sourceforge.net/projects/bsd42/files/Install%20tapes/Research%20Unix/Unix-v6-Ken-Wellsch.tap.bz2/download
https://minnie.tuhs.org/mailman3/hyperkitty/list/tuhs@tuhs.org/thread/CCSLCT7PJSNLRH6A5UZXCWYX4O3TB7U3/

Original boot sequence:

$ docker run -it matushorvath/pdp11 bash
# pdp11 tboot.ini
(run commands from rk.txt)
(press Ctrl+E)
sim> q
#pdp11 dboot.ini
@rkunix
# STTY -LCASE

Improved (no simh restart)

$ docker run -it matushorvath/pdp11 bash
# pdp11 tboot.ini
(run commands from rk.txt)
(press Ctrl+E)
sim> dep system sr 173030
sim> boot rk0
@rkunix
# STTY -LCASE
