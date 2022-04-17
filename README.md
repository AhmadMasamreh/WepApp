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

You should get an output similar to


From the terminal run:

```
kubectl get nodes
```

You should get an output similar to:




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


### Create the deployment
In order to create the deployment of the application in the Kubernetes cluster you need to run the following command from the terminal:

```
kubectl create -f webapp-deployment.yaml
```

This command should return with an output similar to:


Then verify that the deployment was created by running:


You should get an output similar to:



### Create the service

In order to create the service to load balance the application in the Kubernetes cluster you need to run the following command from the terminal:


This command should return with an output similar to:

Then verify that the service was created by running:



You should get an output similar to:



The `CLUSTER-IP` in your case might be different but the ports should indicate the port that the cluster is using to access the application (80) and the port that the cluster node exposes to the world to access the application (31000)

### Test

Run the `kubectl cluster-info` command again to get the IP of the cluster node:


From a browser use that IP and port 31000 to access the application. From the terminal we can use the `curl` command:


You should get an output similar to the following:



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
