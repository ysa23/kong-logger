# Kong Request Logger
A [Kong](https://konghq.com/kong/) plugin for logging http request to a log as a JSON

## Highlights
* Built with performance and low resource environments in mind
* Masks for obfuscating sensative information
* Prevent logs from specific paths
* Can be applied on all basic entities in Kong: service, route, consumer

## Getting started

### Build
The plugin is built using lua and distributed as a rock.
To build the rock run the following in terminal:
```
$ ./build-plugin.sh
```
A file suffixed with `.all.rock` will be generated.

### Install
An example for generating a Kong docker image with the plugin can be found in the `Dockerfile` in the repo.
You can build the image running `./build-docker.sh` script.

### Running on local machine
Run the following command in terminal:
```
$ ./build-docker.sh
$ docker-compose up -d
```
You can access kong via its Admin API (`http://localhost:8001`) , or via [Konga](https://github.com/pantsel/konga) at `localhost:1337`

## How to contribute
We encourage contribution via pull requests on any feature you see fit.

Read [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more details about creating pull requests
