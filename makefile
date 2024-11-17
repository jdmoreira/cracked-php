IMAGE_NAME = cracked-php
BUILDER_NAME = $(IMAGE_NAME)-builder
PLATFORMS = linux/arm64,linux/amd64
BUILD_CONTEXT = .

all: build-and-publish

# Create and use a builder if it doesn't already exist
create-builder:
	@echo "Creating and using a new builder: $(BUILDER_NAME)"
	@if [ -z "$$(docker buildx ls | grep $(BUILDER_NAME))" ]; then \
		docker buildx create --name $(BUILDER_NAME) --use; \
	else \
		echo "Builder $(BUILDER_NAME) already exists, using it."; \
	fi

# Build the image and push it
build-and-publish: create-builder
	@echo "Building and pushing multi-arch image: $(IMAGE_NAME)"
	docker buildx build --platform $(PLATFORMS) -t $(IMAGE_NAME) --push $(BUILD_CONTEXT)

# Clean up the builder and builder cache
clean:
	@echo "Cleaning up builder and builder cache"
	@if [ ! -z "$$(docker buildx ls | grep $(BUILDER_NAME))" ]; then \
		docker buildx rm $(BUILDER_NAME); \
	fi
	docker builder prune -f
