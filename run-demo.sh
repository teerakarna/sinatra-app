#!/bin/sh

# Check dependencies are installed; doesn't care about versions
dep_list=( git docker minikube kubectl )

for i in "${dep_list[@]}"; do
	if ! command -v "$i" >/dev/null 2>&1; then
    	echo -e "Error: Can not find \"$i\" in environment variable $PATH"
    	exit 1
	fi
done

# Check minikube is correctly configured, if not, show output and exit
if ! minikube status >/dev/null 2>&1; then
	minikube status
	exit 1
fi

# Make sure the ingress controller is enabled
minikube addons enable ingress

# Clone GitHub repo
git clone https://github.com/teerakarna/sinatra-demo.git /tmp/sinatra-demo && \

# Build image locally
(
	eval $(minikube docker-env)
	cd /tmp/sinatra-demo
	docker build -t sinatra-demo .
)

# Create deployment for sinatra-demo
kubectl create deployment sinatra-demo --image=sinatra-demo && \

# Patch container template to never pull image from repo
kubectl patch deployment sinatra-demo -p '{"spec":{"template":{"spec":{"containers":[{"name":"sinatra-demo","imagePullPolicy":"Never"}]}}}}' && \

# Restart pods to pick up local image
for i in $(kubectl get po -l=app=sinatra-demo --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'); do kubectl delete po $i; done && \

# Scale to 2 replicas for HA config
kubectl scale deployment sinatra-demo --replicas=2 && \

# Create NodePort service and apply ingress resource
kubectl expose deployment sinatra-demo --type=NodePort --port=4567 && \
kubectl apply -f manifests/ingress.yaml && \

# Output message to user for final manual configuration step
echo -e "\nAdd this to the end of your host file:\n\n\t$(kubectl get ingress sinatra-demo \
	-ojsonpath='{.status.loadBalancer.ingress[].ip}') $(kubectl get ingress sinatra-demo \
    -ojsonpath='{.spec.rules[].host}')\n\nAccess site via this URL:\n\n\thttp://$(kubectl get ingress sinatra-demo \
    -ojsonpath='{.spec.rules[].host}')\n"
