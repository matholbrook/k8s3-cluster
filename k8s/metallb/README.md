# How To

## Set Up MetalLB

We do this first to create the Ingress resources

```bash
$ k create -f metallb-native.yaml 
namespace/metallb-system created
customresourcedefinition.apiextensions.k8s.io/bfdprofiles.metallb.io created
customresourcedefinition.apiextensions.k8s.io/bgpadvertisements.metallb.io created
customresourcedefinition.apiextensions.k8s.io/bgppeers.metallb.io created
customresourcedefinition.apiextensions.k8s.io/communities.metallb.io created
customresourcedefinition.apiextensions.k8s.io/ipaddresspools.metallb.io created
customresourcedefinition.apiextensions.k8s.io/l2advertisements.metallb.io created
customresourcedefinition.apiextensions.k8s.io/servicel2statuses.metallb.io created
serviceaccount/controller created
serviceaccount/speaker created
role.rbac.authorization.k8s.io/controller created
role.rbac.authorization.k8s.io/pod-lister created
clusterrole.rbac.authorization.k8s.io/metallb-system:controller created
clusterrole.rbac.authorization.k8s.io/metallb-system:speaker created
rolebinding.rbac.authorization.k8s.io/controller created
rolebinding.rbac.authorization.k8s.io/pod-lister created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:controller created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:speaker created
configmap/metallb-excludel2 created
secret/metallb-webhook-cert created
service/metallb-webhook-service created
deployment.apps/controller created
daemonset.apps/speaker created
validatingwebhookconfiguration.admissionregistration.k8s.io/metallb-webhook-configuration created
```

```bash
$ k create -f metallb-ipaddresspool.yaml
ipaddresspool.metallb.io/first-pool created
l2advertisement.metallb.io/example created
```

## How to Test MetalLB

### Set it up

```bash
$ kubectl create deploy nginx --image nginx
$ kubectl expose deploy nginx --port 80 --type LoadBalancer

$ kubectl get svc --selector=app=nginx
NAME    TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)        AGE
nginx   LoadBalancer   10.102.36.225   192.168.122.240   80:32463/TCP   4m2s

$ kubectl get svc nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
192.168.122.240
```

The point a web browser to the nginx home page: http://192.168.122.240 or use curl ...

```bash
$ curl http://192.168.122.240
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

### Tear it Down

```bash
$ kubectl delete svc nginx
$ kubectl delete deployment nginx
```

## Install Ingress

```bash
k create -f nginx-ingress-deploy.yaml 
namespace/ingress-nginx created
serviceaccount/ingress-nginx created
serviceaccount/ingress-nginx-admission created
role.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
configmap/ingress-nginx-controller created
service/ingress-nginx-controller created
service/ingress-nginx-controller-admission created
deployment.apps/ingress-nginx-controller created
job.batch/ingress-nginx-admission-create created
job.batch/ingress-nginx-admission-patch created
ingressclass.networking.k8s.io/nginx created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
```

### Check Installation

```bash
$ kubectl -n ingress-nginx get po
NAME                                        READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-c4mx2        0/1     Completed   0          83s
ingress-nginx-admission-patch-vmzcv         0/1     Completed   2          83s
ingress-nginx-controller-7b66b968cf-hdhkq   1/1     Running     0          83s
```

### Test Installation

```bash
$ kubectl create deployment nginx --image=nginx --port=80
$ kubectl get po --selector=app=nginx
NAME                     READY   STATUS    RESTARTS   AGE
nginx-86c57bc6b8-tcpsr   1/1     Running   0          2m45s

$ kubectl expose deployment nginx
service/nginx exposed
$ kubectl get svc --selector=app=nginx
NAME    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
nginx   ClusterIP   10.97.240.232   <none>        80/TCP    10s

$ kubectl create ingress nginx --class=nginx --rule nginx.example.com/=nginx:80
ingress.networking.k8s.io/nginx created
$ kubectl get ing
NAME    CLASS   HOSTS               ADDRESS           PORTS   AGE
nginx   nginx   nginx.example.com   192.168.122.240   80      3m28s
```
we expose the service on the ingress at nginx.example.com.
Modify /etc/hosts to include an entry for this:
192.168.122.240  nginx.example.com

Now use a web browser to go to that URL: http://nginx.example.com

## Cleanup Testing

```bash
kubectl delete ingress nginx
kubectl delete svc nginx
kubectl delete deployment nginx
```
