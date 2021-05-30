KONG_VERSION=2.4.1-alpine
LOGGER_VERSION=0.1.4

./build-plugin.sh

IMAGE_NAME=kong:${KONG_VERSION}-logger-${LOGGER_VERSION}

docker build --build-arg LOGGER_PLUGIN_VERSION=${LOGGER_VERSION} --build-arg KONG_VERSION=${KONG_VERSION} --no-cache -t ${IMAGE_NAME} .