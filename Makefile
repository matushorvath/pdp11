.PHONY: all run pdp11

all: pdp11

pdp11:
	docker build -t matushorvath/pdp11 .

run:
	docker run -it matushorvath/pdp11
