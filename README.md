## Docker and kubernetes 

### lets check kubectl to apiserver connection 

```
[ashu@ip-172-31-27-51 images]$ kubectl  get  nodes
NAME     STATUS   ROLES           AGE   VERSION
master   Ready    control-plane   8d    v1.24.3
node1    Ready    <none>          8d    v1.24.3
node2    Ready    <none>          8d    v1.24.3
```

### OCI format for container images 

<img src="oci.png">

### k8s master and minion communication 

<img src="min.png">

### apiserver 

<img src="api.png">

### schedular 

<img src="sch.png">

### etcd 

<img src="etcd.png">

## Deploy app in k8s 

###  containerize app  ---->> test-push -registry -- Deploy in k8s 

### lets take Nodejs based application 

### bUild and test 

```
[ashu@ip-172-31-27-51 images]$ git clone https://github.com/redashu/nodeapp.git
Cloning into 'nodeapp'...
remote: Enumerating objects: 18, done.
remote: Counting objects: 100% (18/18), done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 18 (delta 1), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (18/18), 4.20 KiB | 4.20 MiB/s, done.
Resolving deltas: 100% (1/1), done.
[ashu@ip-172-31-27-51 images]$ ls
admin.conf  ashu-compose  ashucustomer1  java  node  nodeapp  python  webapps
[ashu@ip-172-31-27-51 images]$ 

```

### Dockerfile inside nodeapp directory 

```
FROM node
# using image from docker hub 
WORKDIR /usr/src/app
# either use this or create new one then use 
# to change directory during image build time 
COPY package*.json .
RUN npm install 
RUN npm ci --only=production 
# if only u r building code for production 
COPY . . 
EXPOSE 8080
CMD ["node","server.js"]


```

### .dockerignore 

```
Dockerfile
.dockerignore
.git
README.md
```

### lets build it 

```
[ashu@ip-172-31-27-51 nodeapp]$ docker build -t docker.io/dockerashu/mobiashunode:v1 .
Sending build context to Docker daemon   5.12kB
Step 1/8 : FROM node
latest: Pulling from library/node
001c52e26ad5: Pull complete 
d9d4b9b6e964: Pull complete 
2068746827ec: Pull complete 
9daef329d350: Pull complete 
8a335986117b: Extracting  48.46MB/197.5MB
80c491fe312f: Download complete 
cb9ad7c100c4: Download complete 
ed0a182e3827: Download compl
```

### creating container for app testing 

```
docker  run -d --name ashutc1 -p 1234:8080 docker.io/dockerashu/mobiashunode:v1
64d18244c15d2d68e76cef146f8d411d36430920a2ce2f7d41f63637e7592aab
[ashu@ip-172-31-27-51 nodeapp]$ docker  ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS         PORTS                                       NAMES
64d18244c15d   dockerashu/mobiashunode:v1   "docker-entrypoint.s…"   6 seconds ago   Up 5 seconds   0.0.0.0:1234->8080/tcp, :::1234->8080/tcp   ashutc1
```

### Deploy container image in k8s --- 

## k8s usages Pod Concept 

<img src="pod.png">


### POd Design 

```
apiVersion: 'v1' # apiserver version 
kind: Pod # resource in k8s to deploy container images 
metadata: # info of pod 
  name: ashupod1 # name of pod 
spec: # about your containerized app
  containers:
  - name: ashuc1
    image: docker.io/dockerashu/mobiashunode:v1
    ports:
    - containerPort: 8080 # container app port 
```

### sending and checking request related to pod 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl create -f  ashupod1.yaml 
pod/ashupod1 created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  pods 
NAME          READY   STATUS              RESTARTS   AGE
ashupod1      0/1     ContainerCreating   0          6s
lakshaypod1   0/1     ContainerCreating   0          1s
nehapod1      0/1     ContainerCreating   0          2s
sharathpod1   0/1     ContainerCreating   0          1s
[ashu@ip-172-31-27-51 k8syamls]$ 

```

### deleting pod 

```
[ashu@ip-172-31-27-51 ~]$ kubectl delete pods  akashpod1 dhruvpod1  divyapod1  gaurikapod1  hemupod1  kanakapod1  saipod1 
pod "akashpod1" deleted
pod "dhruvpod1" deleted
pod "divyapod1" deleted
pod "gaurikapod1" deleted
pod "hemupod1" deleted
pod "kanakapod1" deleted
pod "saipod1" deleted
[ashu@ip-172-31-27-51 ~]$ 

```

### 

```
ashu@ip-172-31-27-51 ~]$ kubectl get po ashupod1 -o wide
NAME       READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
ashupod1   1/1     Running   0          38m   192.168.104.24   node2   <none>           <none>
[ashu@ip-172-31-27-51 ~]$ 


```

### describe pod 

```
[ashu@ip-172-31-27-51 ~]$ kubectl describe pod ashupod1 
Name:         ashupod1
Namespace:    default
Priority:     0
Node:         node2/172.31.27.109
Start Time:   Sat, 13 Aug 2022 06:29:08 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: fff4eb0e02a70dff317484958fcbf4042a107d31e00ef116658090dcd810181d
              cni.projectcalico.org/podIP: 192.168.104.24/32
              cni.projectcalico.org/podIPs: 192.168.104.24/32
Status:       Running
IP:           192.168.104.24
IPs:

```

### access pod container 

```
[ashu@ip-172-31-27-51 ~]$ kubectl exec  -it  ashupod1  -- bash 
root@ashupod1:/usr/src/app# 
root@ashupod1:/usr/src/app# 
root@ashupod1:/usr/src/app# 
root@ashupod1:/usr/src/app# ls
node_modules  package-lock.json  package.json  server.js
root@ashupod1:/usr/src/app# exit
exit
[ashu@ip-1
```

### lets delete pod 

```
[ashu@ip-172-31-27-51 ~]$ kubectl delete pod ashupod1 
pod "ashupod1" deleted


```
### a pod container with some process 

```
apiVersion: v1
kind: Pod
metadata:
  name: ashutoshhpod1
spec:
  containers:
  - name: ashucc11
    image: busybox 
    command: ['sh','-c','ping fb.com']
    
```

### check output of pod container 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get po ashutoshhpod1 
NAME            READY   STATUS    RESTARTS   AGE
ashutoshhpod1   1/1     Running   0          5s
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  logs  ashutoshhpod1 
PING fb.com (157.240.241.35): 56 data bytes
64 bytes from 157.240.241.35: seq=0 ttl=38 time=81.648 ms
64 bytes from 157.240.241.35: seq=1 ttl=38 time=81.647 ms
64 bytes from 157.240.241.35: seq=2 ttl=38 time=81.687 m
```

### copy 

```
 kubectl cp logs.txt ashutoshhpod1:/opt/
```

### kubectl auto generate yaml 

```
[ashu@ip-172-31-27-51 ~]$  kubectl run ashuwebapp1 --image=dockerashu/ashucustomer:v1  --port 80 --dry-run=client  -o yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ashuwebapp1
  name: ashuwebapp1
spec:
  containers:
  - image: dockerashu/ashucustomer:v1
    name: ashuwebapp1
    ports:
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

```

### saving into a file 

```
 kubectl run ashuwebapp1 --image=dockerashu/ashucustomer:v1  --port 80 --dry-run=client  -o yaml  >autopod.yaml
```

### deploy it 

```
[ashu@ip-172-31-27-51 k8syamls]$ ls
ashupod1.yaml  autopod.yaml  logs.txt  task1.yaml
[ashu@ip-172-31-27-51 k8syamls]$ kubectl create -f autopod.yaml 
pod/ashuwebapp1 created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl get pods
NAME          READY   STATUS             RESTARTS   AGE
ashuwebapp1   1/1     Running            0          12s
nehawebapp1   0/1     ImagePullBackOff   0          3m6s
[ashu@ip-172-31-27-51 k8syamls]$ 


```

### final auto generate yAML 

```
[ashu@ip-172-31-27-51 ~]$ kubectl  run  ashupod111 --image=dockerashu/ashucustomer:v1 --port 80 --dry-run=client -o yaml 
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ashupod111
  name: ashupod111
spec:
  containers:
  - image: dockerashu/ashucustomer:v1
    name: ashupod111
    ports:
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
[ashu@ip-172-31-27-51 ~]$ kubectl  run  ashupod111 --image=dockerashu/ashucustomer:v1 --port 80 --dry-run=client -o yaml     >auotgenpod.yaml 
[ashu@ip-172-31-27-51 ~]$ kubectl create  -f  auotgenpod.yaml 
pod/ashupod111 created
[ashu@ip-172-31-27-51 ~]$ kubectl get  pods
NAME           READY   STATUS    RESTARTS   AGE
ashupod111     1/1     Running   0          4s
dimpwebapp1    1/1     Running   0          2m9s
divyawebapp1   1/1     Running   0          2m4s
[ashu@ip-172-31-27-51 ~]$ 

```

### how to get dashbaord password 

```
kubectl -n kubernetes-dashboard   describe secrets dash-secret
```


