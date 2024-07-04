set -e
CONTEXT=clust1

kubectl create --context="$CONTEXT" namespace sample
kubectl label --context="$CONTEXT" namespace sample \
    istio-injection=enabled

kubectl apply --context="$CONTEXT" \
    -f samples/sleep/sleep.yaml -n sample

kubectl apply --context="$CONTEXT" -n sample \
    -f istio-config/http-ingress/clust1-helloworld-stub.yaml

CONTEXT=clust2

kubectl create --context="$CONTEXT" namespace sample
kubectl label --context="$CONTEXT" namespace sample \
    istio-injection=enabled

kubectl apply --context="$CONTEXT" \
    -f samples/helloworld/helloworld.yaml \
    -l service=helloworld -n sample

kubectl apply --context="$CONTEXT" \
    -f samples/helloworld/helloworld.yaml \
    -l version=v2 -n sample

kubectl apply --context="$CONTEXT" -n sample \
    -f istio-config/http-ingress/clust2-helloworld-gateway.yaml

#curl -s -I -HHost:helloworld.sample.svc.cluster.local  http://127.0.0.1:80/hello
#curl -s -I -HHost:helloworld.sample.com  http://127.0.0.1:3002/hello

#curl -s -I -HHost:helloworld.sample.svc.cluster.local  http://127.0.0.1:80/hello
#curl -H Host:helloworld.sample.com  http://localhost:80/hello