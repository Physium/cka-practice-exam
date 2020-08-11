#question 1/8
#etcd backup requires cert in-order to call API=3 ETCD Commands

ETCDCTL_API=3 etcdctl --endpoints https://127.0.0.1:2379 --cert=/etc/kubernetes/pki/etcd/server.crt --cacert=/etc/kubernetes/pki/etcd/ca.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /tmp/etcd-backup.db

etcd
    - --advertise-client-urls=https://172.17.0.54:2379
    - --cert-file=/etc/kubernetes/pki/etcd/server.crt
    - --client-cert-auth=true
    - --data-dir=/var/lib/etcd
    - --initial-advertise-peer-urls=https://172.17.0.54:2380
    - --initial-cluster=master=https://172.17.0.54:2380
    - --key-file=/etc/kubernetes/pki/etcd/server.key
    - --listen-client-urls=https://127.0.0.1:2379,https://172.17.0.54:2379
    - --listen-metrics-urls=http://127.0.0.1:2381
    - --listen-peer-urls=https://172.17.0.54:2380
    - --name=master
    - --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
    - --peer-client-cert-auth=true
    - --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
    - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --snapshot-count=10000
    - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt

#question 2/8
k run redis-storage --image=redis:alpine --restart=Never --dry-run -o yaml > redis-storage.yaml

#question 3/8
k run super-user-pod --image=busybox:1.28 --restart=Never --dry-run -o yaml --command -- sh -c sleep 4800 > super-user-pod.yaml

#question 4/8
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 10Mi

#use-pv.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: use-pv
  name: use-pv
spec:
  containers:
  - image: nginx
  	name: use-pv
    resources: {}
    volumeMounts:
    - mountPath: /data
      name: pvc-map
   volumes:
   - name: pvc-map
     PersistentVolumeClaim:
       claimName: my-pvc
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

#question 5/8
k run nginx-deploy --image=nginx:1.16 --replicas=1 --record
k set image deployment nginx-deploy nginx-deploy=nginx:1.17 --record

#question 6/8

# create CSR for john
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: john-developer
spec:
  request: $(cat john.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

# approve john csr
k certificate approve john-developer

# create role
k create role developer --verb=create,list,get,update,delete --resource=pods -n development

CSR: john-developer Status:Approved
Role Name: developer, namespace: development, Resource: Pods
Access: User 'john' has appropriate permissions

# create role binding
kubectl create rolebinding john-developer-role --role=developer --user=john --namespace=development

#set context
kubectl config --kubeconfig=config-demo set-credentials john --client-certificate=john.csr --client-key=john.key
#kubectl config --kubeconfig=config-demo set-cluster kubernetes --server=https://172.17.0.17:6443 --certificate-authority=fake-ca-file


#question 7/8
k run nginx-resolver --image=nginx --restart=Never --command -- sleep 3600

k expose pod nginx-resolver --port=80 --name=nginx-resolver-service

k run busybox-lookup --image=busybox:1.28 --restart=Never

kubectl exec -it busybox-lookup -- nslookup nginx-resolver-service > /root/nginx.svc

kubectl exec -it busybox-lookup -- nslookup pod-ip.default.pod > /root/nginx.pod

#question 8/8

k run nginx-critical --image=nginx --restart=Never -o yaml > nginx-critical.yaml
#create manifest folder in node01
#scp file from main to node01
