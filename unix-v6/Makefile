.PHONY: all clean pdp11 run

all: pdp11

Unix-v6-Ken-Wellsch.tap:
	wget http://sourceforge.net/projects/bsd42/files/Install%20tapes/Research%20Unix/Unix-v6-Ken-Wellsch.tap.bz2
	bunzip2 Unix-v6-Ken-Wellsch.tap.bz2

pdp11: Unix-v6-Ken-Wellsch.tap
	docker build -t matushorvath/pdp11 .

run:
	docker run -it matushorvath/pdp11

clean:
	rm -f Unix-v6-Ken-Wellsch.tap.bz2 Unix-v6-Ken-Wellsch.tap
