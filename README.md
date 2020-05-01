![LambdaTest Logo](https://www.lambdatest.com/static/images/logo.svg)
---
# LambdaTest docker tunnel
Official docker image for [LambdaTest](https://www.lambdatest.com/) tunnel.

> You need username and accesskey to connect lambdatest tunnel. If you already have an account you can visit [here](https://accounts.lambdatest.com/detail/profile) to fetch your credentails. If you haven't then please signup [here](https://accounts.lambdatest.com/register)

## Usage
The entrypoint of the image is set to the tunnel binary with no extra arguments. Run the image without any arguments to see the help text.

This image supports all the tunnel modifier [flags available](https://www.lambdatest.com/support/docs/lambda-tunnel-modifiers/) in the tunnel command line binary, and passes them as it is to the entry point.


##### Version
```bash
docker run -it  lambdatest/tunnel -v
```

##### Basic


```bash
docker run -it --name lt lambdatest/tunnel -user johndoe -key XXXXXXXXXXXX
```

##### Capturing logs in mounted volume on host machine
```bash
docker run -it  -v /mydir:/logs lambdatest/tunnel -user joendoe -key XXXXXXXX -logFile /logs/tunnel.log
```
##### Using info api on tunnel to fetch tunnel status
> Info API will be available on the host over port 13001. `curl 127.0.0.1:13001/api/v1.0/info` can be used to probe the tunnel status
```bash
docker run -it -p 13001:8000 lambdatest/tunnel -user johndoe -key XXXXXXX  -infoAPIPort 8000  
```

##### Using Proxy running on host machine at port 8082 having foo and bar as username and key
```bash
docker run -it lambdatest/tunnel -user johndoe -key XXXXXXX  -proxy-host host.docker.internal  -proxy-port 8082 -proxy-user foo -proxy-pass bar
```

##### Using Proxy running on another docker container within same default bridge network
> Assuming the container in which proxy is running has IP 172.17.0.2. The IP can be found from inside of the container or by inspecting the network to which container is attached
```bash
docker run -it lambdatest/tunnel -user johndoe -key XXXXXXX  -proxy-host 172.17.0.2  -proxy-port 8082 -proxy-user foo -proxy-pass bar
```

##### Using Proxy running on another docker container within same `custom` bridge network
> When you create custom network, containers can reach each other using container names due to automatic service discovery. Assuming that `custom-network` already exists and container named proxy-service has a proxy server running
```bash
docker run -it lambdatest/tunnel -user johndoe -key XXXXXXX  -proxy-host proxy-service  -proxy-port 8082 -proxy-user foo -proxy-pass bar
```


## Development
* Clone the repo from [github](https://github.com/LambdaTest/docker-tunnel)
* run `docker build -t <build name> <cloned directory>`


## Considerations when testing web applications running on the host machine
By default LambdaTest tunnel can no longer access webapps running on host machines or other docker containers using localhost or 127.0.0.1 when you run it using docker container. This means that the test scripts needs to be modified in the way they accesses the target webapp, according to the docker network topology and host operating system.

#### Linux
On linux, containers can run in a special network mode called `host`. This network mode makes the container use host's network stack and doesn't create an isolated one for the containers.
Running the following command makes tunnel container run with host networking and can access host's network. The test scripts can access services running on host machine using localhost
```bash
docker run -it  --network host lambdatest/tunnel -user johndoe -key XXXXXXXXXXXX
```

#### Mac and Windows
Unfortunately, on both mac and windows, host networking mode is not available due to the implementation of docker machine. The recommended approach to access services on host machine is to use a special host name `host.docker.internal` which resolves to the host machine. You can find more details on these links: [mac](https://docs.docker.com/docker-for-mac/networking/), [windows](https://docs.docker.com/docker-for-windows/networking/)
The test scripts need to use this special hostname in order to access the webservices running on the host machine.

> The idomatic way of testing on docker infra is to create a custom bridge network and access services using their container names. This method works on all operating systems


## About LambdaTest

[LambdaTest](https://www.lambdatest.com/) is a cloud based selenium grid infrastructure that can help you run automated cross browser compatibility tests on 2000+ different browser and operating system environments. LambdaTest supports all programming languages and frameworks that are supported with Selenium, and have easy integrations with all popular CI/CD platforms. It's a perfect solution to bring your [selenium automation testing](https://www.lambdatest.com/selenium-automation) to cloud based infrastructure that not only helps you increase your test coverage over multiple desktop and mobile browsers, but also allows you to cut down your test execution time by running tests on parallel.

## License

Licensed under the [MIT license](./LICENSE).


