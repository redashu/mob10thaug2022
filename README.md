## Docker and kubernetes 

###  apache httpd and NGinx 

### taking sample webapp from github 

```
[ashu@ip-172-31-27-51 images]$ mkdir webapps
[ashu@ip-172-31-27-51 images]$ ls
java  node  python  webapps
[ashu@ip-172-31-27-51 images]$ cd  webapps/
[ashu@ip-172-31-27-51 webapps]$ ls
[ashu@ip-172-31-27-51 webapps]$ git clone https://github.com/Microsoft/project-html-website
Cloning into 'project-html-website'...
remote: Enumerating objects: 19, done.
remote: Total 19 (delta 0), reused 0 (delta 0), pack-reused 19
Receiving objects: 100% (19/19), 462.63 KiB | 7.23 MiB/s, done.
[ashu@ip-172-31-27-51 webapps]$ 

```
### Dockerfile

```

FROM nginx
# image from docker hub 
LABEL email=ashutoshh@linux.com
COPY project-html-website  /usr/share/nginx/html/
# only copy data of project-html folder to nginx/html/
#CMD  start nginx server 
```

### .dockerignore 

```
project-html-website/.git
project-html-website/README.md
project-html-website/LICENSE

```

### lets buidl it 

```
[ashu@ip-172-31-27-51 webapps]$ ls
Dockerfile  project-html-website
[ashu@ip-172-31-27-51 webapps]$ docker  build  -t  ashuwebapp:v1  .  
Sending build context to Docker daemon    834kB
Step 1/3 : FROM nginx
 ---> b692a91e4e15
Step 2/3 : LABEL email=ashutoshh@linux.com
 ---> Running in e7b2c808c2c8
Removing intermediate container e7b2c808c2c8
 ---> 0e2501fdb3f6
Step 3/3 : COPY project-html-website  /usr/share/nginx/html/
 ---> 21836141cae3
Successfully built 21836141cae3
Successfully tagged ashuwebapp:v1
[ashu@ip-172-31-27-51 webapps]$ 
```

### creating container 

```
 docker  run -d  --name ashuwapp1   ashuwebapp:v1 
 
```

## networking in docker 

```
[ashu@ip-172-31-27-51 webapps]$ docker  network  ls
NETWORK ID     NAME      DRIVER    SCOPE
68f6204f6995   bridge    bridge    local
886517202b25   host      host      local
8d1dfc2bb8a4   none      null      local
[ashu@ip-172-31-27-51 webapps]$ docker  network  inspect  bridge
[
    {
        "Name": "bridge",
        "Id": "68f6204f69959d970a5bd876a97865069e906c1483b27352a9dcc81407774d4e",
        "Created": "2022-08-11T03:42:31.421674096Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
```

### checking container networking 

```
 73  docker  inspect  ashuwapp1  --format='{{.Id}}'
   74  docker  inspect  ashuwapp1  --format='{{.State.Status}}'
   75  docker  inspect  ashuwapp1  --format='{{.Id}}'
   76  docker  inspect  ashuwapp1  --format='{{.NetworkSettings.IPAddress}}'
   77  docker  inspect  sankalpwebap  --format='{{.NetworkSettings.IPAddress}}'
   78  docker  inspect  sankalpwebappc1  --format='{{.NetworkSettings.IPAddress}}'
```

### task 3 

```
  1.  create a container of <yourname>cc11 
      2. choose oraclelinux:8.4  as docker image 
      3. any process of container
      4. container must not be able to communitcate to other containers as well not to internet
```

### creating container with port forwarding 

```
 docker run -d  --name ashuwebc1  -p  1234:80  ashuwebapp:v1 
```

### creating custom bridge 

```
 docker  network  inspect  ashubr1 
  docker  network  create   ashubr2   --subnet  193.168.2.0/24  
```

### creating container in above created bridge

```
 docker  run -itd --name ashuc2  --network ashubr1  alpine
```

### creating container with static ip address

```
 docker  run -itd --name ashuc4  --network ashubr2   --ip 193.168.2.100  alpine 
```
