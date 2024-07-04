set -e
CONTEXT=clust1

kubectl create --context="$CONTEXT" namespace sample
kubectl label --context="$CONTEXT" namespace sample \
    istio-injection=enabled

kubectl apply --context="$CONTEXT" \
    -f samples/sleep/sleep.yaml -n sample

kubectl apply --context="$CONTEXT" -n sample \
    -f istio-config/https-ingress/clust1-helloworld-stub.yaml

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
    -f istio-config/https-ingress/clust2-helloworld-gateway.yaml

