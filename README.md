## Docker and kubernetes 

## meeting link

[join here](https://teams.live.com/meet/9546629977527)

## Storage concept 

### creating PV {persistent volume } -- namespace independent Resource 

### YAML of k8s -- for PV 

### creating directory 

```
[ashu@ip-172-31-27-51 images]$ mkdir  storge-deploy
[ashu@ip-172-31-27-51 images]$ cd  storge-deploy/
[ashu@ip-172-31-27-51 storge-deploy]$ 


```
### PV yaml

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ashu-pv1 # name of pv -- this is outside namespace 
spec: 
  storageClassName: local
  accessModes:
  - ReadWriteOnce # RWM /RWO /ROM 
  capacity:
    storage: 3Gi # requesting 3Gb storage 
  hostPath:
    path: /data/ashuvol1
    type: DirectoryOrCreate #  if not present above directory then create it
```

### creating pv 

```
[ashu@ip-172-31-27-51 storge-deploy]$ ls
ashupv.yaml
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl apply -f  ashupv.yaml 
persistentvolume/ashu-pv1 created
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  pv
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
aditi-pv1     3Gi        RWO            Retain           Available           local                   5s
ashu-pv1      3Gi        RWO            Retain           Available           local                   25s
divya-pv1     3Gi        RWO            Retain           Available           local                   7s
ishan-pv1     3Gi        RWO            Retain           Available           local                   2s
lakshay-pv1   7
```

### creating pvc 

```
apiVersion: v1
kind: PersistentVolumeClaim 
metadata: 
  name: ashupvc-db
spec: 
  storageClassName: local 
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi 
```

### creating pvc 

```
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl apply -f ashupvc.yaml 
persistentvolumeclaim/ashupvc-db created
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  pvc
NAME         STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
ashupvc-db   Bound    dimp-pv1   5Gi        RWO            local          83s
[ashu@ip-172-31-27-51 storge-deploy]$ 


```
### creating database deployment in personal namespace 

```
kubectl create  deployment ashudb  --image=mysql:5.6 --port 3306  --dry-run=client -o yaml  >mysqldb-deploy.yaml 
[ashu@ip-172-31-27-51 storge-deploy]$ 
```

### creating secret to store dbroot cred 

```
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  create  secret generic  ashudbsec  --from-literal     mydbpass="Mobidb098#" --dry-run=client -o yaml >dbsecret.yaml 
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  apply -f  dbsecret.yaml 
secret/ashudbsec created
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  secret 
NAME        TYPE     DATA   AGE
ashudbsec   Opaque   1      4s
[ashu@ip-172-31-27-51 storge-deploy]$ 


```

### final deployment yaml 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashudb
  name: ashudb # name of deployment 
spec:
  replicas: 1 # one pod of db 
  selector:
    matchLabels:
      app: ashudb
  strategy: {}
  template: # template will be used to create pod 
    metadata:
      creationTimestamp: null
      labels:
        app: ashudb
    spec:
      volumes: # to create volume for this pod 
      - name: ashuvol001 
        persistentVolumeClaim: # calling pvc 
          claimName: ashupvc-db # name of pvc 
      containers:
      - image: mysql:5.6
        name: mysql
        ports:
        - containerPort: 3306
        resources: {}
        env: # calling env of docker image 
        - name: MYSQL_ROOT_PASSWORD 
          valueFrom: # calling something 
            secretKeyRef: 
              name: ashudbsec # name of secret 
              key: mydbpass # key of secret 
        volumeMounts: # attaching volume to container 
        - name: ashuvol001
          mountPath: /var/lib/mysql/ # location inside container 
status: {}

```

###

```
[ashu@ip-172-31-27-51 storge-deploy]$ ls
ashupvc.yaml  ashupv.yaml  dbsecret.yaml  mysqldb-deploy.yaml
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl apply -f mysqldb-deploy.yaml 
deployment.apps/ashudb created
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  deploy 
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
ashudb   1/1     1            1           10s
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  po
NAME                      READY   STATUS    RESTARTS   AGE
ashudb-5978645458-pw6x8   1/1     Running   0          14s
[ashu@ip-172-31-27-51 storge-deploy]$ 

```

### creating service of clusterIP type for db 

```
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  deploy 
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
ashudb   1/1     1            1           41m
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  expose  deployment  ashudb --type ClusterIP --port 3306  --name ashdbsvc1 --dry-run=client -o yaml >dbsvc.yaml 
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl apply -f  dbsvc.yaml 
service/ashdbsvc1 created
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  svc
NAME        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
ashdbsvc1   ClusterIP   10.103.103.244   <none>        3306/TCP   10s
[ashu@ip-172-31-27-51 storge-deploy]$ 

```


### creating webapp 

```
[ashu@ip-172-31-27-51 storge-deploy]$ ls
ashupvc.yaml  ashupv.yaml  dbsecret.yaml  dbsvc.yaml  mysqldb-deploy.yaml
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  create  deployment  ashuwebapp --image=wordpress:4.8-apache --port 80 --dry-run=client -o yaml >webapp.yaml 
[ashu@ip-172-31-27-51 storge-deploy]$ 


```

### COnfigMap 

```
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl create configmap dbconncet  --from-literal  WORDPRESS_DB_HOST="mydburl" --dry-run=client  -o yaml >dbconfigmap.yaml 
```

### yaml of deployment 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashuwebapp
  name: ashuwebapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashuwebapp
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: ashuwebapp
    spec:
      containers:
      - image: wordpress:4.8-apache
        name: wordpress
        ports:
        - containerPort: 80
        resources: {}
        env: 
        - name: WORDPRESS_DB_PASSWORD 
          valueFrom: # calling 
            secretKeyRef: # secret 
              name: ashudbsec # name of secret 
              key: mydbpass # key of secret 
        envFrom: # for calling env variable from configmap/secret 
        - configMapRef:
            name: dbconncet # name of configmap 

status: {}

```

### creating service 

```
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl apply -f webapp.yaml 
deployment.apps/ashuwebapp created
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  deploy
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
ashudb       1/1     1            1           82m
ashuwebapp   1/1     1            1           86s
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  expose deployment  ashuwebapp --type NodePort --port  80 --name ashuwebsvc1 --dry-run=client -o yaml >websvc.yaml 
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl apply -f websvc.yaml 
service/ashuwebsvc1 created
[ashu@ip-172-31-27-51 storge-deploy]$ kubectl  get  svc
NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
ashdbsvc1     ClusterIP   10.103.103.244   <none>        3306/TCP       42m
ashuwebsvc1   NodePort    10.110.185.189   <none>        80:32300/TCP   72s
[ashu@ip-172-31-27-51 storge-deploy]$ 

```

### context in k8s

```
[ashu@ip-172-31-27-51 images]$ kubectl config get-contexts 
CURRENT   NAME                                                      CLUSTER                                                   AUTHINFO                                                  NAMESPACE
          arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster   arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster   arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster   
*         kubernetes-admin@kubernetes                               kubernetes                                                kubernetes-admin                                          ashu-project
[ashu@ip-172-31-27-51 images]$ 
[ashu@ip-172-31-27-51 images]$ kubectl config use-context arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster
Switched to context "arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster".
[ashu@ip-172-31-27-51 images]$ 


```

### creating namesapce 

```
[ashu@ip-172-31-27-51 ~]$ kubectl  create  ns  ashu-project 
namespace/ashu-project created
[ashu@ip-172-31-27-51 ~]$ kubectl config set-context --current --namespace ashu-project
Context "arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster" modified.
[ashu@ip-172-31-27-51 ~]$ 

```





