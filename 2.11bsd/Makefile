.PHONY: all build clean run

all: build

build: 2.11bsd.tap
	docker build -t matushorvath/2.11bsd .

2.11bsd.tap:
	curl -sS -o $@ https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/2.11BSD-481-simh-dist.tap

run:
	docker run -it matushorvath/2.11bsd

clean:
	rm -f 2.11bsd.tap
