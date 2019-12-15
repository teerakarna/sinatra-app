# sinatra-app

## What does this demo do?

This demo will build a Docker image locally and create a deployment on a [minikube](https://github.com/kubernetes/minikube) instance.

The deployment is configured with 2 replicasets and to ***not*** pull from a remote image repo.

A service is exposed on NodePort which is loadbalanced by an NGINX ingress controller (use [kail](https://github.com/boz/kail) or [stern](https://github.com/wercker/stern) to test responses from both pods).

There is a manual step to add the host definition to `/etc/hosts` so that the ingress endpoint can be opened in a browser.

The app is just a simple API server implemented using [Sinatra](http://sinatrarb.com/).

## Prerequisites

There are a few conditions for this demo to run. You must have a running minikube instance with ingress addon enabled. You are advised to use a fresh minikube instance:

```
$ minikube start
$ minikube addons enable ingress
```

## How to run

Download the Bash script [run-demo.sh](run-demo.sh) and run in terminal:

```
$ curl https://raw.githubusercontent.com/teerakarna/sinatra-demo/master/run-demo.sh -o run-demo.sh
$ bash run-demo.sh
```
