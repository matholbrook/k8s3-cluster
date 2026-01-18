# How To

helm repo add metallb https://metallb.github.io/metallb

helm repo update

kubectl create namespace metallb-system

kubectl config set-context --current --namespace metallb-system

helm install metallb metallb/metallb

cat <<EOF > metallb-ipaddresspool.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: k8s3-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.122.230-192.168.122.239
EOF

cat <<EOF > metallb-l2advertisement.yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: k8s3-pool-advertisement
  namespace: metallb-system
spec:
  ipAddressPools:
  - k8s3-pool
EOF

kubectl create -f metallb-ipaddresspool.yaml

kubectl create -f metallb-l2advertisement.yaml

