# ¡ATENCIÓN! Esto hay que cambiarlo también en el FROM del Dockerfile
BASE_IMAGE_NAME=mcr.microsoft.com/devcontainers/python:3.12-bookworm
IMAGE_NAME=python:3.12-devcontainer
IMAGE_SAVE_NAME=python_3_12_devcontainer

# Ejecuta la imagen base para depurar
base_image_run:
	@docker run -ti --rm \
		--user vscode:vscode \
		-v $(shell pwd):$(shell pwd) \
		--workdir $(shell pwd) \
		--entrypoint /bin/bash \
		$(BASE_IMAGE_NAME)

# Build
build:
	@docker build --force-rm -t $(IMAGE_NAME) .

# Ejecuta la imagen construída
run:
	@docker run -ti --rm \
		--user vscode:vscode \
		--name python_test \
		-v $(shell pwd):$(shell pwd) \
		--workdir $(shell pwd) \
		--entrypoint /bin/bash \
		$(IMAGE_NAME)

# Respaldo a tar.gz de la imagen
save:
	@docker image save $(IMAGE_NAME) $(IMAGE_NAME) | gzip > \
		$(IMAGE_SAVE_NAME).tar.gz
