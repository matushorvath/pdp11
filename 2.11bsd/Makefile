.PHONY: all build clean run tape very-clean

all: build

build: tape
	docker build -t matushorvath/2.11bsd .

TAPE_FILES = boot disklabel file6.tar file7.tar file8.tar icheck mkfs mtboot restor root.dump

tape: tape/bsd.tap

tape/bsd.tap: $(patsubst %,tape/%,$(TAPE_FILES))
	perl simh_tape.pl

tape/file6.tar: tape/file6.tar.gz
tape/file7.tar: tape/file7.tar.gz
tape/file8.tar: tape/file8.tar.gz

tape/%:
	curl -sS --create-dirs -o $@ https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481/$(@F)

tape/%.tar: tape/%.tar.gz
	gzip -dk $<
	touch $@

run:
	docker run -it matushorvath/2.11bsd

clean:
	rm -rf tape/bsd.tap tape/*.tar

very-clean:
	rm -rf tape
