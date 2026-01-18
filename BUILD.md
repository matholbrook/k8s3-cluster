# How To

## Tear It Down

```bash
terraform destroy --auto-approve
ssh-keygen -f '/home/mat/.ssh/known_hosts' -R 'k8s3-vm1'
ssh-keygen -f '/home/mat/.ssh/known_hosts' -R 'k8s3-vm2'
ssh-keygen -f '/home/mat/.ssh/known_hosts' -R 'k8s3-vm3'
```

## Create VM's

```bash
cd terraform
export TF_IN_AUTOMATION=true
terraform init -reconfigure
terraform plan -out=main.plan
terraform apply -auto-approve
```

## Patch VM's

```bash
ansible-playbook -i ../ansible/k8s3-hosts.ini ../../../ansible/apt.yaml
```

## Set up Kubernetes

```bash
ansible-playbook -i ../ansible/k8s3-hosts.ini ../../../ansible/k8s.yaml
```

## Create k8s Cluster

```bash
ansible-playbook -i ../ansible/k8s3-hosts.ini ../ansible/playbooks/ansible-playbook_k8s-cluster-calico.yaml
```

## Configure Host PC

```bash
ssh-keygen -f '/home/mat/.ssh/known_hosts' -R 'k8s3-vm1'
ssh mat@k8s3-vm1 -i ~/.ssh/mh-k8s-ecdsa "cat ~/.kube/config" > ~/.kube/k8s3-config
export KUBECONFIG=~/.kube/k8s3-config
$ kubectl get no
NAME       STATUS     ROLES           AGE    VERSION
k8s1-vm1   NotReady   control-plane   119s   v1.32.6
k8s1-vm2   NotReady   <none>          105s   v1.32.6
k8s1-vm3   NotReady   <none>          106s   v1.32.6

$ kubectl -n kube-system get pods
NAME                               READY   STATUS    RESTARTS   AGE
coredns-668d6bf9bc-696l6           0/1     Pending   0          2m1s
coredns-668d6bf9bc-8v7s7           0/1     Pending   0          2m1s
etcd-k8s1-vm1                      1/1     Running   0          2m10s
kube-apiserver-k8s1-vm1            1/1     Running   0          2m8s
kube-controller-manager-k8s1-vm1   1/1     Running   0          2m8s
kube-proxy-67h2r                   1/1     Running   0          2m2s
kube-proxy-8z8lg                   1/1     Running   0          117s
kube-proxy-gl78s                   1/1     Running   0          117s
kube-scheduler-k8s1-vm1            1/1     Running   0          2m8s
``` 
Note that the DNS pods are pending.  We haven't installed the network plugin yet.


## Label Worker Nodes

```bash
kubectl label no k8s3-vm2 node-role.kubernetes.io/worker=worker
kubectl label no k8s3-vm3 node-role.kubernetes.io/worker=worker
```

## Install k8s Network Plugin

```bash
kubectl create -f ../../../k8s/calico/calico.yaml
kubectl -n kube-system get po -w
```

## Install k8s Metrics Server

```bash
kubectl create -f ../../../k8s/metrics-server/components.yaml
kubectl -n kube-system get po -w
```

## Install MetalLB

## Install ArgoCD with Helm

```bash
helm repo add argo
helm repo update
kubectl create namespace argocd
helm install argocd argo/argo-cd -n argocd

```
