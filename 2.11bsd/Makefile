.PHONY: all build clean run very-clean

all: build

build: 2.11bsd.tap data.tar
	docker build -t matushorvath/2.11bsd .

2.11bsd.tap:
	curl -sS -o $@ https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/2.11BSD-481-simh-dist.tap

data.tar: data/Makefile.patch data/SIMH data/fstab data/rc.patch
	tar cvf $@ $^

run:
	docker run -it -p 8080:80/tcp matushorvath/2.11bsd

clean:
	rm -f data.tar

very-clean: clean
	rm -f 2.11bsd.tap
