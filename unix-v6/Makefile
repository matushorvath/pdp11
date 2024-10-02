.PHONY: all clean pdp11 run

all: build

build: unix-v6.tap
	docker build -t matushorvath/unix-v6 .

unix-v6.tap:
	curl -sSL https://sourceforge.net/projects/bsd42/files/Install%20tapes/Research%20Unix/Unix-v6-Ken-Wellsch.tap.bz2 | bunzip2 > $@

pdp11: Unix-v6-Ken-Wellsch.tap
	docker build -t matushorvath/pdp11 .

run:
	docker run -it matushorvath/pdp11

clean:
	rm -f unix-v6.tap
