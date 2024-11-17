IMAGE_NAME = cracked-php
PORT_MAPPING = -p 80:80 -p 443:443 -p 443:443/udp
VOLUME_MAPPING = -v $(PWD)/launcher:/launcher -v $(PWD)/app:/app
BUILD_CONTEXT = ..

# Default target: build
all: build

# Build the image locally
build:
	@echo "Building image: $(IMAGE_NAME)"
	docker build -t $(IMAGE_NAME) -f $(BUILD_CONTEXT)/Dockerfile $(BUILD_CONTEXT)

# Clean up the image locally
clean:
	@echo "Cleaning up image: $(IMAGE_NAME)"
	docker rmi -f $(IMAGE_NAME) || true

# Run the container with HTTP and HTTPS using port mapping and volume mapping
run:
	@echo "Running container: $(IMAGE_NAME)"
	docker run -d --name $(IMAGE_NAME) \
		$(PORT_MAPPING) \
		$(VOLUME_MAPPING) \
		$(IMAGE_NAME)

# Stop and remove the running container
stop:
	@echo "Stopping and removing container: $(IMAGE_NAME)"
	docker stop $(IMAGE_NAME) && docker rm $(IMAGE_NAME)

# Restart the container
restart: stop run
