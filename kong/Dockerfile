ARG KONG_VERSION

FROM kong:$KONG_VERSION

USER root

ARG LOGGER_PLUGIN_VERSION

COPY kong-plugin-kong-logger-$LOGGER_PLUGIN_VERSION-1.all.rock /tmp
RUN su - -c "luarocks install /tmp/kong-plugin-kong-logger-$LOGGER_PLUGIN_VERSION-1.all.rock"
RUN cp /etc/kong/kong.conf.default /etc/kong/kong.conf ; echo 'plugins = bundled,kong-logger' >> /etc/kong/kong.conf

USER kong