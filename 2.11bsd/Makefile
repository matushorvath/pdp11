.PHONY: build run

build:
	docker run --rm -i hadolint/hadolint hadolint - < Dockerfile
	docker build -t pdp11 --target pdp11 .
	docker build -t pdp11-2.11bsd --target pdp11-2.11bsd .
	docker build -t pdp11-2.11bsd-httpd --target pdp11-2.11bsd-httpd .

run:
	docker run -it -p 8080:80/tcp pdp11-2.11bsd-httpd
