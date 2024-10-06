.PHONY: build run

build:
	docker run --rm -i hadolint/hadolint hadolint --ignore DL3008 - < Dockerfile
	docker build -t matushorvath/unix-v6 .

run:
	docker run -it matushorvath/unix-v6
