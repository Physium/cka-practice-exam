alias k=kubectl

#question 1/12
k run nginx-pod --image=nginx:alpine --restart=Never

#question 2/12
k run messaging --image=redis:alpine --restart=Never --label="tier=msg"

#question 3/12
k create ns apx-x9984574

#question 4/12
k get nodes -o json > /opt/outputs/nodes-z3444kd9.json

#question 5/12
k expose pod messaging --name=messaging-service --port=6379

#question 6/12
k run hr-web-app --image=kodekloud/webapp-color --replicas=2

#question 7/12
k run static-busybox --image=busybox --restart=Never --dry-run -o yaml  --command -- sleep 1000  > /etc/kubernetes/manifests/static-busybox.yaml

#question 8/12
k run temp-bus --image=redis:alpine --restart=Never --namespace=finance\

#question 9/12
#--command issues

#question 10/12
k expose deployment hr-web-app --name=hr-web-app-service --type=NodePort --port=8080
k edit service hr-web-app-service #change nodeport port to 30082

#question 11/12
k get nodes -o=jsonpath="{.items[*].status.nodeInfo.osImage}" > /opt/outputs/nodes_os_x43kj56.txt

#question 12/12
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-analytics
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  hostPath:
  	path: /pv/data-analytics