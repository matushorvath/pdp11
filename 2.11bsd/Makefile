.PHONY: build run

build:
	docker run --rm -i hadolint/hadolint hadolint --ignore DL3008 - < Dockerfile
	docker build -t matushorvath/2.11bsd .

run:
	docker run -it -p 8080:80/tcp matushorvath/2.11bsd
