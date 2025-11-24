.PHONY: build build-pdp11 build-unix-v6 build-2.11bsd lint run run-2.11bsd-httpd

build: build-unix-v6 build-2.11bsd

build-pdp11: lint
	docker build -t matushorvath/pdp11 --target pdp11 .

build-unix-v6: lint
	docker build -t matushorvath/pdp11-unix-v6 --target pdp11-unix-v6 .

build-2.11bsd: lint
	docker build -t matushorvath/pdp11-2.11bsd --target pdp11-2.11bsd .
	docker build -t matushorvath/pdp11-2.11bsd-httpd --target pdp11-2.11bsd-httpd .

lint:
	docker run --rm -i hadolint/hadolint hadolint - < Dockerfile

run: run-2.11bsd-httpd

run-2.11bsd-httpd:
	docker run -it matushorvath/pdp11-2.11bsd-httpd
