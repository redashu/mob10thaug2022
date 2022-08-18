## Docker and kubernetes 

### cleaning up namespace data 

```
ashu@ip-172-31-27-51 images]$ kubectl delete deploy,svc,pod  --all
deployment.apps "ashudeploy1" deleted
service "ashulb001" deleted
pod "ashudeploy1-7fd896568d-b5wqc" deleted
pod "ashudeploy1-7fd896568d-rglz6" deleted
[ashu@ip-172-31-27-51 images]$ 
```

### creating deployment using ECR image 

```
[ashu@ip-172-31-27-51 images]$ ls
admin.conf  ashu-compose  ashucustomer1  ashumobiwebapp  java  k8syamls  node  nodeapp  python  webapps
[ashu@ip-172-31-27-51 images]$ cd  k8syamls/
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  create  deployment   ashuecrapp  --image=724915917086.dkr.ecr.us-west-2.amazonaws.com/mobiwebapp:ashuappv1    --port 80 --dry-run=client -o yaml  >ecrdeploy.yaml 
[ashu@ip-172-31-27-51 k8syamls]$ 

```

### deploy 

```
ashu@ip-172-31-27-51 k8syamls]$ kubectl apply -f ecrdeploy.yaml 
deployment.apps/ashuecrapp created
[ashu@ip-172-31-27-51 k8syamls]$ 
[ashu@ip-172-31-27-51 k8syamls]$ 
[ashu@ip-172-31-27-51 k8syamls]$ 
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get deploy 
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
ashuecrapp   0/1     1            0           16s
[ashu@ip-172-31-27-51 k8syamls]$ 
```

### Deploying image with OCR registry 

```
kubectl create  deployment  ashuocrdeploy --image=phx.ocir.io/axmbtg8judkl/ashuweb:mobiv1  --port 80  --dry-run=client -o yaml >ocrdeploy.yaml
```

### see status 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl apply -f  ocrdeploy.yaml 
deployment.apps/ashuocrdeploy created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl get deploy 
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
ashuocrdeploy   0/1     1            0           5s
[ashu@ip-172-31-27-51 k8syamls]$ kubectl get  po 
NAME                             READY   STATUS         RESTARTS   AGE
ashuocrdeploy-67ff554c69-sqkbg   0/1     ErrImagePull   0          9s
[ashu@ip-172-31-27-51 k8syamls]$ 
```
### creating secret 

```
[ashu@ip-172-31-27-51 ~]$ kubectl create secret 
Create a secret using specified subcommand.

Available Commands:
  docker-registry   Create a secret for use with a Docker registry
  generic           Create a secret from a local file, directory, or literal value
  tls               Create a TLS secret

Usage:
  kubectl create secret [flags] [options]


```

### creating 

```
 818  kubectl create secret   docker-registry  ashu-regcred  --docker-server="phx.ocir.io"  --docker-username="axyme@gmail.com"  --docker-password="8Y[vO7;6L(0S.{"  --dry-run=client -o yaml >secret.yaml
  819  history 
[ashu@ip-172-31-27-51 k8syamls]$ kubectl apply -f  secret.yaml 
secret/ashu-regcred created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  secret  
NAME           TYPE                             DATA   AGE
ashu-regcred   kubernetes.io/dockerconfigjson   1      5s

```

### YAML File 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashuocrdeploy
  name: ashuocrdeploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashuocrdeploy
  strategy: {}
  template: # will be used to create pods 
    metadata:
      creationTimestamp: null
      labels:
        app: ashuocrdeploy
    spec:
      imagePullSecrets: # to call secret from same namespace 
      - name: ashu-regcred # check using kubectl get secret 
      containers:
      - image: phx.ocir.io/axmbtg8judkl/ashuweb:mobiv1
        name: ashuweb
        ports:
        - containerPort: 80
        resources: {}
status: {}

```

### deploy it 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl replace -f  ocrdeploy.yaml  --force 
deployment.apps "ashuocrdeploy" deleted
deployment.apps/ashuocrdeploy replaced
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  secret 
NAME           TYPE                             DATA   AGE
ashu-regcred   kubernetes.io/dockerconfigjson   1      8m59s
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get deploy 
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
ashuocrdeploy   1/1     1            1           24s
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get po 
NAME                             READY   STATUS    RESTARTS   AGE
ashuocrdeploy-5f8bf77bd9-vjltn   1/1     Running   0          31s
[ashu@ip-172-31-27-51 k8syamls]$ 
```





