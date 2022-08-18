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




