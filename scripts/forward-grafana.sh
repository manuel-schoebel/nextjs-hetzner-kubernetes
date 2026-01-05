#!/bin/bash
# Forward Grafana to localhost:3000

echo "Forwarding Grafana to http://localhost:3000"
echo "Default credentials: admin / (check secrets or run below command)"
echo "kubectl get secret kube-prometheus-stack-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d"
echo ""

kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80
