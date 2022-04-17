# Ruby Web Application in Kubernetes

## Overview
This repository contains a sample application written in Ruby.

## Prerequisites:
- Docker to be installed.
- Minikube to be installed.
- Sudo User access.
- A browser to test, or you can use w3m, and install it by sudo apt-get install w3m w3m-img.


## Application Deployment:

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

You should get an output similar to

```
Kubernetes master is running at https://192.168.99.100:8443
KubeDNS is running at https://192.168.99.100:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

From the terminal run:

```
kubectl get nodes
```

You should get an output similar to:

```
NAME       STATUS    ROLES     AGE       VERSION
minikube   Ready     master    3d        v1.13.4



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
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
webapp                                0.0.1               34052bc5ef21        37 minutes ago      873MB

### Create the deployment
In order to create the deployment of the application in the Kubernetes cluster you need to run the following command from the terminal:

```
kubectl create -f webapp-deployment.yaml
```

This command should return with an output similar to:

```
deployment.apps "webapp" created
```

Then verify that the deployment was created by running:

```
kubectl get deployments
```

You should get an output similar to:

```
NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
webapp   2         2         2            2           39m
```

Note the `DESIRED` and `CURRENT` count which denote the number of pods that we want to use and how many to we currently have.

### Create the service

In order to create the service to load balance the application in the Kubernetes cluster you need to run the following command from the terminal:

```
kubectl create -f webapp-service.yaml
```

This command should return with an output similar to:

```
service "webapp" created
```

Then verify that the service was created by running:

```
kubectl get services
```

You should get an output similar to:

```
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
webapp   LoadBalancer   10.111.20.145   <pending>     80:31000/TCP   41m
kubernetes   ClusterIP      10.96.0.1       <none>        443/TCP        3d
```

The `CLUSTER-IP` in your case might be different but the ports should indicate the port that the cluster is using to access the application (80) and the port that the cluster node exposes to the world to access the application (31000)

### Test

Run the `kubectl cluster-info` command again to get the IP of the cluster node:

```
Kubernetes master is running at https://192.168.99.100:8443
KubeDNS is running at https://192.168.99.100:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

From a browser use that IP and port 31000 to access the application. From the terminal we can use the `curl` command:

```
curl http://192.168.99.100:31000
```

You should get an output similar to the following:

```
Hello world! my IP is 172.17.0.6
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



## Thank you :)
