# Kong Request Logger
A [Kong](https://konghq.com/kong/) plugin for logging http request to a log as a JSON

## Highlights
* Built with performance and low resource environments in mind
* Logs request headers, query parameters, request body, response headers and response code (+ overhaul kong operational parameters)
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

To install on enterprise edition, revise the base image in `Dockerfile` to your available Kong Enterprise image.

### Enable the plugin
To enable the plugin globally run the following a terminal with access to Kong's admin API:
```
$ curl -X POST http://kong-url:8001/plugins \
    --data "name=kong-logger"  \
    --data "config.masks=token,password,email" \
    --data "config.path_filters=/health"
```

### Configuration

#### masks
An array of field names to mask in the log. </br>
Field name can be:
* Header name
* Query string parameter name
* Request body field (JSON) - will also scan nested fields as well

#### path_filters
An array of URI paths, which won't be logged by the logger. Any request that will have partial match to one of the items specified in the list will not be logged.

### Running on local machine
Run the following command in terminal:
```
$ ./build-docker.sh
$ docker-compose up -d
```
You can access kong via its Admin API (`http://localhost:8001`) , or via [Konga](https://github.com/pantsel/konga) at `localhost:1337`

### Log example
The plugin currently logs the requests as error logs in the following format:
```
kong_1             | 2021/05/15 09:36:56 [error] 24#0: *2483 [kong] handler.lua:86 [kong-logger]{"request":{"querystring":{"apikey":"******","name":"yossi","jwt":"******"},"size":277,"headers":{"accept":"*/*","host":"localhost:8000","content-length":"67","content-type":"application/json","user-agent":"curl/7.64.1","password":"******"},"body":{"id":"12345","child":{"token":"******"}},"method":"POST","uri":"/test","url":"http://localhost:8000/test"},"latencies":{"kong":2,"request":2,"proxy":-1},"client_ip":"192.168.16.1","response":{"status":200,"size":208,"headers":{"connection":"close","content-type":"application/json","x-kong-response-latency":"2","server":"kong/2.4.1","content-length":"28"}}}[/kong-logger], context: ngx.timer, client: 192.168.16.1, server: 0.0.0.0:8000
```

To extract the JSON you can use the following regex:
```js
// Javascript
const regex = /\[kong-logger\](?<json>.+)\[\/kong-logger\]/
```

JSON after extraction:
```json
{
  "request": {
    "querystring": {
      "apikey": "******",
      "name": "yossi",
      "jwt": "******"
    },
    "size": 277,
    "headers": {
      "accept": "*/*",
      "host": "localhost:8000",
      "content-length": "67",
      "content-type": "application/json",
      "user-agent": "curl/7.64.1",
      "password": "******"
    },
    "body": {
      "id": "12345",
      "child": {
        "token": "******"
      }
    },
    "method": "POST",
    "uri": "/test",
    "url": "http://localhost:8000/test"
  },
  "latencies": {
    "kong": 2,
    "request": 2,
    "proxy": -1
  },
  "client_ip": "192.168.16.1",
  "response": {
    "status": 200,
    "size": 208,
    "headers": {
      "connection": "close",
      "content-type": "application/json",
      "x-kong-response-latency": "2",
      "server": "kong/2.4.1",
      "content-length": "28"
    }
  }
}
```

Original request:
```
curl --location --request POST 'http://localhost:8000/test?name=yossi&apikey=anapikey&jwt=1234' \
    --header 'Content-Type: application/json' \
    --header 'password: simplepassword' \
    --data-raw '{
        "id": "12345",
        "child": {
        "token": "abcdef"
        }
    }'
```

## How to contribute
We encourage contribution via pull requests on any feature you see fit.

Read [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more details about creating pull requests.