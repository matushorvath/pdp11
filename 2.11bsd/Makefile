.PHONY: build run

build:
	docker run --rm -i hadolint/hadolint hadolint - < Dockerfile
	docker build -t matushorvath/pdp11 --target pdp11 .
	docker build -t matushorvath/pdp11-2.11bsd --target pdp11-2.11bsd .
	docker build -t matushorvath/pdp11-2.11bsd-httpd --target pdp11-2.11bsd-httpd .

run:
	docker run -it -p 8080:80/tcp matushorvath/pdp11-2.11bsd-httpd

define publish-image
	docker image tag $(PDP11_IMAGE) $(PDP11_IMAGE):v$(PDP11_VERSION)
	docker image push $(PDP11_IMAGE):v$(PDP11_VERSION)
	docker image tag $(PDP11_IMAGE) $(PDP11_IMAGE):v$(firstword $(subst ., ,$(PDP11_VERSION)))
	docker image push $(PDP11_IMAGE):v$(firstword $(subst ., ,$(PDP11_VERSION)))
	docker image tag $(PDP11_IMAGE) $(PDP11_IMAGE):latest
	docker image push $(PDP11_IMAGE):latest
endef

publish: build
	[ ! -z "$(PDP11_VERSION)" ] || ( echo PDP11_VERSION variable needs to be set >&2 ; exit 1 )

	$(eval PDP11_IMAGE = matushorvath/pdp11)
	$(publish-image)

	$(eval PDP11_IMAGE = matushorvath/pdp11-2.11bsd)
	$(publish-image)

	$(eval PDP11_IMAGE = matushorvath/pdp11-2.11bsd-httpd)
	$(publish-image)
