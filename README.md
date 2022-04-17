# Ruby Web Application in Kubernetes

## Overview
This repository contains a sample application written in Ruby.

## Prerequisites:
- Docker to be installed.
- Minikube to be installed.
- Sudo User access.
- A browser to test, or you can use w3m, and install it by sudo apt-get install w3m w3m-img.


## Application Deployment:

### Clone from git repository
```
$ git  clone https://github.com/AhmadMasamreh/WebApp.git
```

```
cd ./WebApp
```


### Verify your docker & minikube installation

From the terminal run:

```
kubectl cluster-info
```

You should get an output similar to :
```
Kubernetes control plane is running at https://192.168.49.2:8443
CoreDNS is running at https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

From the terminal run:

```
kubectl get nodes
```

You should get an output similar to:

```
minikube   Ready    control-plane,master   2m25s   v1.23.3
```

### Create the container image
The first step to deploy the application is to create the container image that we will use to run the application in the cluster.

In order to do that we first need to run the command to use the Docker environment from the `minikube` cluster. From the terminal run:

```
eval $(minikube docker-env)
```

Then from the same terminal we run the following commands to build the container image:
```
docker build -t webapp:0.0.1 -f webapp.dockerfile .
```

Then verify that the image was created:
```
docker images
```

You should see the image in the output similar to:

```
REPOSITORY                                TAG       IMAGE ID       CREATED          SIZE
webapp                                    0.0.1     8537df62b725   20 seconds ago   843MB
k8s.gcr.io/kube-apiserver                 v1.23.3   f40be0088a83   2 months ago     135MB
k8s.gcr.io/kube-controller-manager        v1.23.3   b07520cd7ab7   2 months ago     125MB
k8s.gcr.io/kube-proxy                     v1.23.3   9b7cc9982109   2 months ago     112MB
k8s.gcr.io/kube-scheduler                 v1.23.3   99a3486be4f2   2 months ago     53.5MB
k8s.gcr.io/etcd                           3.5.1-0   25f8c7f3da61   5 months ago     293MB
k8s.gcr.io/coredns/coredns                v1.8.6    a4ca41631cc7   6 months ago     46.8MB
k8s.gcr.io/pause                          3.6       6270bb605e12   7 months ago     683kB
ruby                                      2.5       27d049ce98db   9 months ago     843MB
kubernetesui/dashboard                    v2.3.1    e1482a24335a   10 months ago    220MB
kubernetesui/metrics-scraper              v1.0.7    7801cfc6d5c0   10 months ago    34.4MB
gcr.io/k8s-minikube/storage-provisioner   v5        6e38f40d628d   12 months ago    31.5MB
```

### Create the deployment
In order to create the deployment of the application in the Kubernetes cluster you need to run the following command from the terminal:

```
kubectl create -f webapp-deployment.yaml
```

This command should return with an output similar to:
```
deployment.apps/webapp created
```

Then verify that the deployment was created by running:

```
kubectl get deployment
```

You should get an output similar to:

```
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
webapp   2/2     2            2           83s
```

### Create the service

In order to create the service to load balance the application in the Kubernetes cluster you need to run the following command from the terminal:

```
kubectl create -f webapp-deployment.yaml
```

This command should return with an output similar to:

```
service/webapp created
```


Then verify that the service was created by running:

```
kubectl get service
```

You should get an output similar to:
```
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP      10.96.0.1       <none>        443/TCP        12m
webapp       LoadBalancer   10.97.177.159   <pending>     80:31000/TCP   67s
```

The `CLUSTER-IP` in your case might be different but the ports should indicate the port that the cluster is using to access the application (80) and the port that the cluster node exposes to the world to access the application (31000)

### Test

Run the `kubectl cluster-info` command again to get the IP of the cluster node:

```
Kubernetes control plane is running at https://192.168.49.2:8443
CoreDNS is running at https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

From a browser use that IP and port 31000 to access the application. From the terminal we can use the `curl` command:

```
curl http://192.168.49.2:31000
```


You should get an output similar to the following:

```
Hello! Pod IP is 172.17.0.4
Hello! Pod IP is 172.17.0.3
```

Run the command multiple times and you will see that the IP changes to reflect that the requests are load balanced between the pods.

## Remove the application

To tear down the service and deployment run the following commands:

```
kubectl delete service webapp
```
```
kubectl delete deployment webapp
```

To delete the container image run:

```
docker image rm $(docker images --filter reference=webapp* --format "{{.ID}}")
```


## Thank you :)
