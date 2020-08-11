k create serviceaccount pvviewer

k create clusterrole pvviewer-role --verb=list --resource=persistentvolumes

k create clusterrolebinding pvviwer-role-binding --clusterrole=pvviewer-role --serviceaccount=default:pvviewer

k run pvviewer --image=redis --serviceaccount=pvviewer --restart=Never

#2
k get nodes -o=jsonpath='{.items[*].status.addresses[0].address}'

k get nodes -o=jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > /root/node_ips

#3 multi-pod.yaml

#4 non-root-pod.yaml

#5 ingress-to-nptest.yaml

#6
k taint nodes node01 env_type=production:NoSchedule
# prod-redis.yaml

#7
k create ns hr #if needed
k run hr-pod --namespace hr --image=redis:alpine --restart=Never --labels="environment=production,tier=frontend"

#8 
kubeconfig file kubeapi wrong

#9
troubleshoot cluster