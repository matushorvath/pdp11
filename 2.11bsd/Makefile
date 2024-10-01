.PHONY: all build clean run tape very-clean

all: build

build: tape
	#docker build -t matushorvath/2.11bsd .

TAPE_FILES = boot disklabel file6.tar file7.tar file8.tar icheck mkfs mtboot restor root.dump

tape: tape/bsd.tap

tape/bsd.tap: $(patsubst %,tape/%,$(TAPE_FILES))
	cat tape/mtboot tape/mtboot tape/boot | dd of=$@ obs=512
	dd if=tape/disklabel of=$@ obs=1024
	dd if=tape/mkfs of=$@ obs=1024
	dd if=tape/restor of=$@ obs=1024
	dd if=tape/icheck of=$@ obs=1024
	dd if=tape/root.dump of=$@ obs=10240
	dd if=tape/file6.tar of=$@ obs=10240
	dd if=tape/file7.tar of=$@ obs=10240
	dd if=tape/file8.tar of=$@ obs=10240

tape/file6.tar: tape/file6.tar.gz
tape/file7.tar: tape/file7.tar.gz
tape/file8.tar: tape/file8.tar.gz

tape/%:
	curl -sS --create-dirs -o $@ https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD/$(@F)

tape/%.tar: tape/%.tar.gz
	gzip -dk $<
	touch $@

run:
	#docker run -it matushorvath/2.11bsd

clean:
	rm -rf tape/bsd.tap tape/*.tar

very-clean:
	rm -rf tape
