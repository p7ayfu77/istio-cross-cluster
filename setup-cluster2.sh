set -e

# Create/Start cluster 
minikube start -p clust2 --driver=docker
#    --docker-env HTTP_PROXY=http://host.docker.internal:9000 \
#    --docker-env HTTPS_PROXY=http://host.docker.internal:9000

# Create Secret for certs
pushd certs
kubectl config use-context clust2

kubectl create namespace istio-system
kubectl create secret generic cacerts -n istio-system \
      --from-file=cluster2/ca-cert.pem \
      --from-file=cluster2/ca-key.pem \
      --from-file=cluster2/root-cert.pem \
      --from-file=cluster2/cert-chain.pem
popd

./bin/istioctl install --context="clust2" -y \
    -f istio-config/default-clust2.yaml

# Run the below in a separate terminal
# minikube tunnel -p clust2
