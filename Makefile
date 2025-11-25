
.PHONY: build
build: unix-v6 2.11bsd 2.11bsd-httpd

.PHONY: pdp11
pdp11: lint
	docker build -t matushorvath/pdp11 --target pdp11 .

.PHONY: unix-v6
unix-v6: pdp11
	docker build -t matushorvath/pdp11-unix-v6 --target pdp11-unix-v6 .

.PHONY: 2.11bsd
2.11bsd: pdp11
	docker build -t matushorvath/pdp11-2.11bsd --target pdp11-2.11bsd .

.PHONY: 2.11bsd-httpd
2.11bsd-httpd: 2.11bsd
	docker build -t matushorvath/pdp11-2.11bsd-httpd --target pdp11-2.11bsd-httpd .

.PHONY: lint
lint:
	yamllint .
	docker run --rm -i hadolint/hadolint hadolint - < Dockerfile

.PHONY: run
run: run-2.11bsd-httpd

.PHONY: run-2.11bsd-httpd
run-2.11bsd-httpd:
	docker run -it matushorvath/pdp11-2.11bsd-httpd
