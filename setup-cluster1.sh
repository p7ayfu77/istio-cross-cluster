set -e

# Create/Start cluster 
minikube start -p clust1 --driver=docker 
#    --docker-env HTTP_PROXY=http://host.docker.internal:9000 \
#    --docker-env HTTPS_PROXY=http://host.docker.internal:9000

# Create Secret for certs
pushd certs
kubectl config use-context clust1

kubectl create namespace istio-system
kubectl create secret generic cacerts -n istio-system \
      --from-file=cluster1/ca-cert.pem \
      --from-file=cluster1/ca-key.pem \
      --from-file=cluster1/root-cert.pem \
      --from-file=cluster1/cert-chain.pem
popd

./bin/istioctl install --context="clust1" -y \
    -f istio-config/default-clust1.yaml