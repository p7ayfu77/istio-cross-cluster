# Cross cluster Istio integration without discovery

This repo showcases two simple examples to achieve cross-cluster comminucation with Istio, but without a fully implemented Mesh integration with and EastWest gateway.

## Setup Local Env

Install:

1. Docker Desktop with WSL2 support
2. Minikube
3. Download istioctl package and extract contents direcly in this repo
4. Generate a set of common root certificates for two clusters, [see steps 1-3 from documentation here](https://istio.io/latest/docs/tasks/security/cert-management/plugin-ca-cert/). 

## Setup mock Local and Remote clusters

Here we instantiate a set of named minikube clusters `clust1` and `clust2` using the `docker` driver:

1. execute the script `setup-cluster1.sh` 
2. execute the script `setup-cluster2.sh` 

Then we enable a tunnel to `clust2` from your local environment network.
In a dedicated terminal execute the following and keep it open:

```
$ minikube tunnel -p clust2
```

Then update the IP address for `host.minikube.internal` in:

1. http-ingress/clust1-helloworld-stub.yaml
2. https-ingress/clust1-helloworld-stub.yaml

This will different for your setup and can be retrieved by executing:

```
$ kubectl config use-context clust1
$ kubectl -n sample exec -it sleep-5577c64d7c-j9gcc -c sleep -- sh
$ nslookup host.minikube.internal
```

## Example: HTTP ingress to Clust2

Executing the script `test-http.sh` will configure:

1. a `sleep` deployment in `clust1`
2. a `helloworld` deployment `clust2` 
3. a stub `Service` in `clust1` with supporting `ServiceEntry` and `WorkloadEntry`
4. a `Gateway` in `clust2` with supporting `VirtualService` 

Test with:

```
$ kubectl config use-context clust1
$ kubectl -n sample exec -it sleep-5577c64d7c-j9gcc -c sleep -- sh
$ curl -H Host:helloworld.sample.com  http://helloworld.sample:5000/hello
Hello version: v2, instance: helloworld-v2-779454bb5f-kbq24
```

## Example: HTTPS ingress to Clust2

1. a `sleep` deployment in `clust1`
2. a `helloworld` deployment `clust2` 
3. a stub `Service` in `clust1` with supporting `WorkloadEntry` and `DestinationRule`
4. a `Gateway` in `clust2` 

Test with:

```
$ kubectl config use-context clust1
$ kubectl -n sample exec -it sleep-5577c64d7c-j9gcc -c sleep -- sh
$ curl http://helloworld.sample:5000/hello
Hello version: v2, instance: helloworld-v2-779454bb5f-kbq24
```
