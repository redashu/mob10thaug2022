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





