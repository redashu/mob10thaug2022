## Docker and kubernetes 

### installing kubectl on linux

```
[root@ip-172-31-27-51 ~]# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   154  100   154    0     0   1653      0 --:--:-- --:--:-- --:--:--  1655
100 43.5M  100 43.5M    0     0  42.9M      0  0:00:01  0:00:01 --:--:-- 54.8M
[root@ip-172-31-27-51 ~]# ls
hii.txt  kubectl
[root@ip-172-31-27-51 ~]# mv kubectl  /usr/bin/
[root@ip-172-31-27-51 ~]# chmod +x  /usr/bin/kubectl 
[root@ip-172-31-27-51 ~]# 
[root@ip-172-31-27-51 ~]# 


```

### testing it 

```
kubectl version --client 
WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
Client Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.3", GitCommit:"aef86a93758dc3cb2c658dd9657ab4ad4afc21cb", GitTreeState:"clean", BuildDate:"2022-07-13T14:30:46Z", GoVersion:"go1.18.3", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.4
```

### 

```
[ashu@ip-172-31-27-51 ashu-compose]$ kubectl version --client  -o yaml 
clientVersion:
  buildDate: "2022-07-13T14:30:46Z"
  compiler: gc
  gitCommit: aef86a93758dc3cb2c658dd9657ab4ad4afc21cb
  gitTreeState: clean
  gitVersion: v1.24.3
  goVersion: go1.18.3
  major: "1"
  minor: "24"
  platform: linux/amd64
kustomizeVersion: v4.5.4
```

====

```
[ashu@ip-172-31-27-51 ashu-compose]$ kubectl version --client  -o json 
{
  "clientVersion": {
    "major": "1",
    "minor": "24",
    "gitVersion": "v1.24.3",
    "gitCommit": "aef86a93758dc3cb2c658dd9657ab4ad4afc21cb",
    "gitTreeState": "clean",
    "buildDate": "2022-07-13T14:30:46Z",
    "goVersion": "go1.18.3",
    "compiler": "gc",
    "platform": "linux/amd64"
  },
  "kustomizeVersion": "v4.5.4"
}
```

### sending request to master  for getting nodes 

```
ashu@ip-172-31-27-51 images]$ kubectl  get nodes   --kubeconfig  admin.conf 
NAME     STATUS   ROLES           AGE   VERSION
master   Ready    control-plane   8d    v1.24.3
node1    Ready    <none>          8d    v1.24.3
node2    Ready    <none>          8d    v1.24.3
```

### api-server

```
[ashu@ip-172-31-27-51 images]$ kubectl  cluster-info   --kubeconfig  admin.conf 
Kubernetes control plane is running at https://54.188.36.8:6443
CoreDNS is running at https://54.188.36.8:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

```

### setting kubeconfig file at the right location 

```
[ashu@ip-172-31-27-51 images]$ mkdir  ~/.kube 
mkdir: cannot create directory ‘/home/ashu/.kube’: File exists
[ashu@ip-172-31-27-51 images]$ 
[ashu@ip-172-31-27-51 images]$ 
[ashu@ip-172-31-27-51 images]$ cp -v admin.conf  ~/.kube/config 
‘admin.conf’ -> ‘/home/ashu/.kube/config’
[ashu@ip-172-31-27-51 images]$ 
[ashu@ip-172-31-27-51 images]$ 
[ashu@ip-172-31-27-51 images]$ kubectl  get nodes  
NAME     STATUS   ROLES           AGE   VERSION
master   Ready    control-plane   8d    v1.24.3
node1    Ready    <none>          8d    v1.24.3
node2    Ready    <none>          8d    v1.24.3
[ashu@ip-172-31-27-51 images]$ 
```



