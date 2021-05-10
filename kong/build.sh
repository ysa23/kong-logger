LOGGER_VERSION=0.1.2

luarocks make
luarocks pack kong-plugin-kong-logger ${LOGGER_VERSION}