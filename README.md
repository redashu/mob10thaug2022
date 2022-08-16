## Docker and kubernetes 

### getting started with ci tool jenkins 

```
 484  cd  ashumobiwebapp/
  485  ls
  486  git clone https://github.com/redashu/mobiwebapp.git
  487  ls
  488  cp -v docker-compose.yaml   mobiwebapp/
  489  cp -v Dockerfile   mobiwebapp/
  490  cp -v index.html   mobiwebapp/
  491  cp -v docker.png   mobiwebapp/
  492  cp -v .dockerignore  mobiwebapp/

```

### adding code to git repo with commit 

```
495  cd  mobiwebapp/
  496  ls  -a
  497  git  add  . 
  498  git commit -m  "first change to app "
  499  git config --global user.email ashutoshh@linux.com
  500  git config --global user.name  redashu
  501  history 
[ashu@ip-172-31-27-51 mobiwebapp]$ git commit -m  "first change to app "
[master 803e4c9] first change to app
 5 files changed, 31 insertions(+)
 create mode 100644 .dockerignore
 create mode 100644 Dockerfile
 create mode 100644 docker-compose.yaml
 create mode 100644 docker.png
 create mode 100644 index.html
```

### git push code 

```
[ashu@ip-172-31-27-51 mobiwebapp]$ git push origin master  
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 8 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (7/7), 3.60 KiB | 3.60 MiB/s, done.
Total 7 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/redashu/mobiwebapp.git
   6499085..803e4c9  master -> master
[ashu@ip-172-31-27-51 mobiwebapp]$ 
```

### YAML for pod 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  run   ashupod1  --image=alpine  --dry-run=client  -o yaml  >ashutest.yaml
548  kubectl create -f  ashutest.yaml 
  549  kubectl  get  pods
```

### creating pod with webapp 

```
kubectl  run   ashuwebpod   --image=dockerashu/ashuapp:mobiv1 --port 80 --dry-run=client    -o yaml  >webpod.yaml 
```

####

```
ashu@ip-172-31-27-51 k8syamls]$ kubectl  run   ashuwebpod   --image=dockerashu/ashuapp:mobiv1 --port 80 --dry-run=client    -o yaml  >webpod.yaml 
[ashu@ip-172-31-27-51 k8syamls]$ ls
ashupod1.yaml  ashutest.yaml  autopod.yaml  logs.txt  task1.yaml  webpod.yaml
[ashu@ip-172-31-27-51 k8syamls]$ kubectl create  -f  webpod.yaml 
pod/ashuwebpod created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  po   |   grep -i ashu
ashuwebpod    1/1     Running            0          10s
[ashu@ip-172-31-27-51 k8syamls]$ 


```

### checking pod 

```
ashu@ip-172-31-27-51 ~]$ kubectl  get  po  -o wide
NAME            READY   STATUS         RESTARTS   AGE     IP                NODE    NOMINATED NODE   READINESS GATES
aditipod        0/1     ErrImagePull   0          6m25s   192.168.104.9     node2   <none>           <none>
akashwebpod     1/1     Running        0          3m43s   192.168.104.23    node2   <none>           <none>
ashuwebpod      1/1     Running        0          5m37s   192.168.104.19    node2   <none>           <none>
deepakwebpod    1/1     Running        0          4m35s   192.168.166.171   node1   <none>           <none>
dhruvpod2       1/1     Runni
```

### namespace in k8s 

```
[ashu@ip-172-31-27-51 ~]$ kubectl  get namespaces 
NAME                   STATUS   AGE
default                Active   12d
feroz                  Active   71s
kube-node-lease        Active   12d
kube-public            Active   12d
kube-system            Active   12d
kubernetes-dashboard   Active   11d
[ashu@ip-172-31-27-51 ~]$ 



```

### creating ns 

```
[ashu@ip-172-31-27-51 ~]$ kubectl create  namespace   ashu-project   
namespace/ashu-project created
[ashu@ip-172-31-27-51 ~]$ kubectl get  ns
NAME                   STATUS   AGE
ashu-project           Active   4s

```

### setting current namespaces 

```
[ashu@ip-172-31-27-51 ~]$ kubectl create  namespace   ashu-project   
namespace/ashu-project created
[ashu@ip-172-31-27-51 ~]$ kubectl get  ns
NAME                   STATUS   AGE
ashu-project           Active   4s
default                Active   12d
dhruvproject           Active   4s
kube-node-lease        Active   12d
kube-public            Active   12d
kube-system            Active   12d
kubernetes-dashboard   Active   11d
[ashu@ip-172-31-27-51 ~]$ kubectl  config set-context --current --namespace ashu-project 
Context "kubernetes-admin@kubernetes" modified.
[ashu@ip-172-31-27-51 ~]$ 
[ashu@ip-172-31-27-51 ~]$ kubectl config get-contexts 
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin   ashu-project
[ashu@ip-172-31-27-51 ~]$ 



```

### creating pod 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl create -f  webpod.yaml 
pod/ashuwebpod created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get pods
NAME         READY   STATUS    RESTARTS   AGE
ashuwebpod   1/1     Running   0          8s
[ashu@ip-172-31-27-51 k8syamls]$ 
[ashu@ip-172-31-27-51 k8syamls]$ 
[ashu@ip-172-31-27-51 k8syamls]$ kubectl config get-contexts 
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin   ashu-project
[ashu@ip-172-31-27-51 k8syamls]$ 

```

## creating service in k8s 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  po -o wide
NAME         READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
ashuwebpod   1/1     Running   0          60m   192.168.104.62   node2   <none>           <none>
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  create  service  
Create a service using a specified subcommand.

Aliases:
service, svc

Available Commands:
  clusterip      Create a ClusterIP service
  externalname   Create an ExternalName service
  loadbalancer   Create a LoadBalancer service
  nodeport       Create a NodePort service

Usage:
  kubectl create service [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  create  service   nodeport 
```

### creating nodeport service 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  create  service   nodeport  ashulb1  --tcp 1234:80   --dry-run=client  -o yaml  >nodeport.yaml     
[ashu@ip-172-31-27-51 k8syamls]$ 



```

### creating service 

```
[ashu@ip-172-31-27-51 k8syamls]$ ls
ashupod1.yaml  autopod.yaml  nodeport.yaml  webpod.yaml
ashutest.yaml  logs.txt      task1.yaml
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  create  -f  nodeport.yaml 
service/ashulb1 created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  service
NAME      TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
ashulb1   NodePort   10.103.155.175   <none>        1234:30718/TCP   5s
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  svc
NAME      TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
ashulb1   NodePort   10.103.155.175   <none>        1234:30718/TCP   10s
[ashu@ip-172-31-27-51 k8syamls]$ 

```

### updating label 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  po --show-labels 
NAME         READY   STATUS    RESTARTS   AGE   LABELS
ashuwebpod   1/1     Running   0          90m   run=ashuwebpod
[ashu@ip-172-31-27-51 k8syamls]$ kubectl replace -f webpod.yaml --force 
pod "ashuwebpod" deleted
pod/ashuwebpod replaced
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  po --show-labels 
NAME         READY   STATUS    RESTARTS   AGE   LABELS
ashuwebpod   1/1     Running   0          4s    x=ashuapps
[ashu@ip-172-31-27-51 k8syamls]$ 


```

### 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl get po --show-labels 
NAME         READY   STATUS    RESTARTS   AGE     LABELS
ashuwebpod   1/1     Running   0          3m28s   x=ashuapps
[ashu@ip-172-31-27-51 k8syamls]$ 
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get svc -o wide
NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
ashulb1   NodePort   10.102.22.126   <none>        1234:30868/TCP   31s   x=ashuapps
[ashu@ip-172-31-27-51 k8syamls]$ 


```





