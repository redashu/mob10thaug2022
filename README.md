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

==
## case 1 -- No ingress.  

### creating nodeport service ---

```
ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  deploy 
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
ashuocrdeploy   1/1     1            1           56m
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  po 
NAME                             READY   STATUS    RESTARTS   AGE
ashuocrdeploy-5f8bf77bd9-vjltn   1/1     Running   0          56m
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  secret
NAME           TYPE                             DATA   AGE
ashu-regcred   kubernetes.io/dockerconfigjson   1      65m
[ashu@ip-172-31-27-51 k8syamls]$ kubectl   expose deploy  ashuocrdeploy --type NodePort  --port  80 --name ashulb1 --dry-run=client  -o yaml  >ocrsvc.yaml
[ashu@ip-172-31-27-51 k8syamls]$ kubectl apply -f ocrsvc.yaml 
service/ashulb1 created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  svc
NAME      TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
ashulb1   NodePort   10.100.165.208   <none>        80:32544/TCP   7s
[ashu@ip-172-31-27-51 k8syamls]$ 

```


## case 2 -- using Ingress 

### creating cluster IP service 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl   expose deploy  ashuocrdeploy --type ClusterIP  --port  80 --name ashulb1 --dry-run=client  -o yaml  >ocrsvc.yaml
[ashu@ip-172-31-27-51 k8syamls]$ kubectl apply -f ocrsvc.yaml 
service/ashulb1 created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  svc
NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
ashulb1   ClusterIP   10.108.63.223   <none>        80/TCP    5s
[ashu@ip-172-31-27-51 k8syamls]$ 

```

### Ingress rule 

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ashutoshh-app-rule # name of my rule 
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx  # name of class- provider name 
  rules:
  - host: me.ashutoshh.in
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ashulb1 # name of service  
            port:
              number: 80 # port of service 
```

### deploy 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl apply -f ingressrule.yaml 
ingress.networking.k8s.io/ashutoshh-app-rule created
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  ing 
NAME                 CLASS   HOSTS             ADDRESS   PORTS   AGE
ashutoshh-app-rule   nginx   me.ashutoshh.in             80      18s
```

### context commands 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl config get-contexts 
CURRENT   NAME                                                      CLUSTER                                                   AUTHINFO                                                  NAMESPACE
          arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster   arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster   arn:aws:eks:us-east-1:751136288263:cluster/mobi-cluster   
*         kubernetes-admin@kubernetes                               kubernetes                                                kubernetes-admin                                          ashu-project
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  config use-context  kubernetes-admin@kubernetes
Switched to context "kubernetes-admin@kubernetes".
[ashu@ip-172-31-27-51 k8syamls]$ 
[ashu@ip-172-31-27-51 k8syamls]$ kubectl config set-context --current --namespace ashu-project 
Context "kubernetes-admin@kubernetes" modified.
[ashu@ip-172-31-27-51 k8syamls]$ 

```

## Deployment strategy 

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl scale deploy  ashuocrdeploy  --replicas=3
deployment.apps/ashuocrdeploy scaled
[ashu@ip-172-31-27-51 k8syamls]$ kubectl get deploy 
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
ashuocrdeploy   3/3     3            3           4h10m
[ashu@ip-172-31-27-51 k8syamls]$ kubectl get po 
NAME                             READY   STATUS    RESTARTS   AGE
ashuocrdeploy-5d955cc5dc-4m5nw   1/1     Running   0          60m
ashuocrdeploy-5d955cc5dc-f9xj2   1/1     Running   0          12s
ashuocrdeploy-5d955cc5dc-p9gz5   1/1     Running   0          12s
[ashu@ip-172-31-27-51 k8syamls]$ 

```

### nodeport service creation

```
[ashu@ip-172-31-27-51 k8syamls]$ kubectl get  svc
No resources found in ashu-project namespace.
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  deploy 
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
ashuocrdeploy   3/3     3            3           4h12m
[ashu@ip-172-31-27-51 k8syamls]$ kubectl expose deployment ashuocrdeploy --type NodePort --port 80 --name ashulb2
service/ashulb2 exposed
[ashu@ip-172-31-27-51 k8syamls]$ kubectl  get  svc
NAME      TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
ashulb2   NodePort   10.108.35.2   <none>        80:31152/TCP   7s
[ashu@ip-172-31-27-51 k8syamls]$ 
```

### deploy rollout 

```
861  kubectl rollout restart deployment d1 
  862  kubectl rollout status  deployment d1 
  863  kubectl create ns  tasks

```





