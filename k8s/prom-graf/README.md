# How To

## Set up Storage First!

```bash
kubectl apply -f storage-class.yaml
kubectl apply -f prometheus-pv1.yaml
kubectl apply -f prometheus-pv2.yaml
```
If you don't do this first then there are several pods that will not start.


## Helm Work

```bash
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories
```

```bash
$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "prometheus-community" chart repository
Update Complete. ⎈Happy Helming!⎈
```

## Prometheus Install

```bash
$ kubectl create ns monitoring
$ helm install prometheus prometheus-community/prometheus --namespace monitoring
NAME: prometheus
LAST DEPLOYED: Tue Apr 29 17:20:09 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
prometheus-server.default.svc.cluster.local


Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9090


The Prometheus alertmanager can be accessed via port 9093 on the following DNS name from within your cluster:
prometheus-alertmanager.default.svc.cluster.local


Get the Alertmanager URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=alertmanager,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9093
#################################################################################
######   WARNING: Pod Security Policy has been disabled by default since    #####
######            it deprecated after k8s 1.25+. use                        #####
######            (index .Values "prometheus-node-exporter" "rbac"          #####
###### .          "pspEnabled") with (index .Values                         #####
######            "prometheus-node-exporter" "rbac" "pspAnnotations")       #####
######            in case you still need it.                                #####
#################################################################################


The Prometheus PushGateway can be accessed via port 9091 on the following DNS name from within your cluster:
prometheus-prometheus-pushgateway.default.svc.cluster.local


Get the PushGateway URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus-pushgateway,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9091

For more information on running Prometheus, visit:
https://prometheus.io/
```

## Grafana Install

```bash
$ helm install grafana grafana/grafana --namespace monitoring
NAME: grafana
LAST DEPLOYED: Tue Apr 29 17:30:57 2025
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:

   kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

   grafana.monitoring.svc.cluster.local

   Get the Grafana URL to visit by running these commands in the same shell:
     export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace monitoring port-forward $POD_NAME 3000

3. Login with the password from step 1 and the username: admin
#################################################################################
######   WARNING: Persistence is disabled!!! You will lose your data when   #####
######            the Grafana pod is terminated.                            #####
#################################################################################
```

## Storage

```bash
$ kubectl get storageclass
NAME       PROVISIONER                    RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
standard   kubernetes.io/no-provisioner   Delete          WaitForFirstConsumer   true                   20m

$ kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
storageclass.storage.k8s.io/standard patched

$ kubectl get storageclass
NAME                 PROVISIONER                    RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
standard (default)   kubernetes.io/no-provisioner   Delete          WaitForFirstConsumer   true                   22m
```

## Expose Service as Loadbalancer

```bash
$ kubectl -n monitoring expose svc grafana --type=LoadBalancer --name=grafana-console
service/grafana-console exposed

$ kubectl -n monitoring get svc grafana-console
NAME              TYPE           CLUSTER-IP     EXTERNAL-IP       PORT(S)        AGE
grafana-console   LoadBalancer   10.108.5.157   192.168.122.231   80:31902/TCP   2m1s 
```

## Set up Grafana Console

```bash
$ echo '192.168.122.231  grafana.local' | sudo tee -a /etc/hosts

$ kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
UKIZBFpxOouMh4lnc7Ek2f10fphwfC2gHzvSlnGh
```

open a browser and navigate to: http://grafana.local:3000
sign in with the user id 'admin' and the password from above

## Set up Prometheus Console

```bash

```
