.PHONY: all build clean run

all: build

build: unix-v6.tap
	docker build -t matushorvath/unix-v6 .

unix-v6.tap:
	curl -sSL https://sourceforge.net/projects/bsd42/files/Install%20tapes/Research%20Unix/Unix-v6-Ken-Wellsch.tap.bz2 | bunzip2 > $@

run:
	docker run -it matushorvath/unix-v6

clean:
	rm -f unix-v6.tap
