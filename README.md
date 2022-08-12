## Docker and kubernetes 

### Docker clients and POrtainer as webui 

### install portainer to manage containers 

```
 docker run -d  --name webui -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --restart always  portainer/portainer 
Unable to find image 'portainer/portainer:latest' locally
latest: Pulling from portainer/portainer
b890dbc4eb27: Pull complete 
81378af8dad0: Pull complete 
Digest: sha256:958a8e5c814e2610fb1946179a3db598f9b5c15ed90d92b42d94aa99f039f30b
Status: Downloaded newer image for portainer/portainer:latest
13d6eafcb56b18ad4033cfb632139fcbb02e12b4586a3928ee5a88d24f28361d
[root@ip-172-31-27-51 ~]# 

```

### customer multple apps 

```
[ashu@ip-172-31-27-51 images]$ mkdir  customer1
[ashu@ip-172-31-27-51 images]$ ls
ashu-compose  customer1  java  node  python  webapps
[ashu@ip-172-31-27-51 images]$ cd  customer1/
[ashu@ip-172-31-27-51 customer1]$ 

```

### code share URL 

[click_here](https://codeshare.io/78bXno)

### 3 apps 

```
211  git clone https://github.com/microsoft/project-html-website.git
  212  git clone https://github.com/schoolofdevops/html-sample-app.git
  213  git clone https://github.com/yenchiah/project-website-template.git
```

### .dockeringore 

```
html-sample-app/.git
html-sample-app/*.txt
project-html-website/.git
project-html-website/LICENSE
project-html-website/README.md
project-website-template/.git
project-website-template/.gitignore
project-website-template/LICENSE
project-website-template/README.md
```

#### dockerfile 

```
FROM oraclelinux:8.4
LABEL name="ashutoshh"
LABEL email="ashutoshh@linux.com"
ENV deploy=sampleapp 
# to define env in docker image but optional these days 
RUN yum install httpd -y && mkdir -p /apps/{app1,app2,app3}
COPY html-sample-app /apps/app1/ 
COPY project-html-website  /apps/app2/
COPY project-website-template /apps/app3/
COPY deploy.sh /apps/
WORKDIR /apps
RUN chmod +x  deploy.sh 
# to change directory for this image during build time 
ENTRYPOINT ["./deploy.sh"]


```

### shell script

```
#!/bin/bash
if  [  "$deploy"  ==  "webapp1"   ]
then
    cp -rf /apps/app1/*  /var/www/html/
    httpd -DFOREGROUND 

elif  [  "$deploy"  ==  "webapp2"   ]
then
    cp -rf /apps/app2/*  /var/www/html/
    httpd -DFOREGROUND 

elif  [  "$deploy"  ==  "webapp3"   ]
then
    cp -rf /apps/app3/*  /var/www/html/
    httpd -DFOREGROUND 
else 
    echo "Wrong variable name " >/var/www/html/index.html
    httpd -DFOREGROUND
fi 
```

### compose file 

```
version: '3.8'
networks: # creating bridge 
  ashubr111: # name of bridge 
services:
  ashuwebapp1:
    image: docker.io/dockerashu/ashuwebday3:v1 
    build: . 
    container_name: ashuwebapp1  # name of container 
    restart: always # restart policy of container 
    ports:
    - "1234:80" # port forwarding 
    networks: # bridge to use 
      - ashubr111 # name of bridge 

```

### lets run it 

```
[ashu@ip-172-31-27-51 ashucustomer1]$ docker-compose up -d  --build 
[+] Building 0.9s (13/13) FINISHED                                                                                            
 => [internal] load build definition from Dockerfile                                                                     0.0s
 => => transferring dockerfile: 514B                                                                                     0.0s
 => [internal] load .dockerignore                                                                                        0.0s
 => => transferring context: 304B                                                                                        0.0s
 => [internal] load metadata for docker.io/library/oraclelinux:8.4                                                       0.1s
 => CACHED [1/8] FROM docker.io/library/oraclelinux:8.4@sha256:b81d5b0638bb67030b207d28586d0e714a811cc612396dbe3410db40  0.0s
 => [internal] load build context                                                                                        0.1s
 => => transferring context: 4.57MB                                                                                      0.1s
 => CACHED [2/8] RUN yum install httpd -y && mkdir -p /apps/{app1,app2,app3}                                             0.0s
 => CACHED [3/8] COPY html-sample-app /apps/app1/                                                                        0.0s
 => CACHED [4/8] COPY project-html-website  /apps/app2/                                                                  0.0s
 => CACHED [5/8] COPY project-website-template /apps/app3/                                                               0.0s
 => [6/8] COPY deploy.sh /apps/                                                                                          0.1s
 => [7/8] WORKDIR /apps                                                                                                  0.0s
 => [8/8] RUN chmod +x  deploy.sh                                                                                        0.5s
 => exporting to image                                                                                                   0.0s
 => => exporting layers                                                                                                  0.0s
 => => writing image sha256:601d5bec2ab78b338353d50c8b40b2e954d550e487829e018bcc66178ff7f71d                             0.0s
 => => naming to docker.io/dockerashu/ashuwebday3:v1                                                                     0.0s
[+] Running 2/2
 ⠿ Network ashucustomer1_ashubr111  Created                                                                              0.1s
 ⠿ Container ashuwebapp1            Started
```

### 

```
[ashu@ip-172-31-27-51 ashucustomer1]$ docker-compose ps
NAME                COMMAND             SERVICE             STATUS              PORTS
ashuwebapp1         "./deploy.sh"       ashuwebapp1         running             0.0.0.0:1234->80/tcp, :::1234->80/tcp
[ashu@ip-172-31-27-51 ashucustomer1]$ 
```

### pushing image to docker hub 

```
ashu@ip-172-31-27-51 ashucustomer1]$ docker login -u dockerashu
Password: 
WARNING! Your password will be stored unencrypted in /home/ashu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
[ashu@ip-172-31-27-51 ashucustomer1]$ docker push  dockerashu/ashuwebday3:v1  
The push refers to repository [docker.io/dockerashu/ashuwebday3]
cee506c83821: Pushed 
5f70bf18a086: Pushed 
2eb3f5ba4018: Pushed 
537e4e99c1d9: Pushed 
0c9d26b91f7e: Pushed 
1c75741d450f: Pushed 
4dd16b911939: Pushed 
2d3586eacb61: Mounted from dockerashu/ashutask5 
v1: digest: sha256:d331f480e0be48308b43163dcb2387
```

### COmpsoe with env 

```
version: '3.8'
networks: # creating bridge 
  ashubr111: # name of bridge 
services:
  ashuwebapp1:
    image: docker.io/dockerashu/ashuwebday3:v1 
    build: . 
    container_name: ashuwebapp1  # name of container 
    restart: always # restart policy of container 
    ports:
    - "1234:80" # port forwarding 
    networks: # bridge to use 
      - ashubr111 # name of bridge 
    environment: # passing env to docker container 
      deploy: webapp3 

```

### Docker image pusing to ECR 

#### tagging 

```
docker  tag  37ea3552b449   724915917086.dkr.ecr.us-west-2.amazonaws.com/mobiwebapp:ashuappv1
```

### login 

```
[ashu@ip-172-31-27-51 ashucustomer1]$ docker login  724915917086.dkr.ecr.us-west-2.amazonaws.com  
Username: AWS
Password: 
WARNING! Your password will be stored unencrypted in /home/ashu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

```

### pushing

```


[ashu@ip-172-31-27-51 ashucustomer1]$ docker push  724915917086.dkr.ecr.us-west-2.amazonaws.com/mobiwebapp:ashuappv1  
The push refers to repository [724915917086.dkr.ecr.us-west-2.amazonaws.com/mobiwebapp]
597bdbec50a4: Pushed 
5f70bf18a086: Pushed 
a89826938cf4: Pushed 
74f962d0a246: Pushed 
bb8569cc10f2: Pushed 
235e47f5f599: Pushed 
a31901591acf: Pushed 
2d3586eacb61: Pushed 
ashuappv1: digest: sha256:10559c992e2c2d1761f50a7704ae0b57c53e15b0170d9bd47aa6909da3c1e6ce size: 1994
[ashu@ip-172-31-27-51 ashucustomer1]$ 
```

### logout 

```
[ashu@ip-172-31-27-51 ashucustomer1]$ docker logout  724915917086.dkr.ecr.us-west-2.amazonaws.com  
Removing login credentials for 724915917086.dkr.ecr.us-west-2.amazonaws.com
```

## Storage in docker 

### container are ephemral by default 

### creating container with some data


```
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  run -dit --name ashut1  --restart always alpine 
580cb1bbad60e79450f17d8fe642698623609c23d86afc8f9da93196a6f4c829
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  exec -it ashut1  sh 
/ # mkdir hello
/ # echo hello world  >/hello/hi.txt 
/ # 
/ # ls  hello/
hi.txt
/ # exit
```

### stopping container is not causing data loss

```
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  kill ashut1 
ashut1
[ashu@ip-172-31-27-51 ashucustomer1]$ docker start  ashut1 
ashut1
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  exec ashut1  ls  /hello 
hi.txt
[ashu@ip-172-31-27-51 ashucustomer1]$ 

```

### creating volume 

```
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  volume  ls
DRIVER    VOLUME NAME
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  volume  create  ashuvol1 
ashuvol1
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  volume  inspect  ashuvol1 
[
    {
        "CreatedAt": "2022-08-12T09:25:44Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/ashuvol1/_data",
        "Name": "ashuvol1",
        "Options": {},
        "Scope": "local"
    }
]
[ashu@ip-172-31-27-51 ashucustomer1]$ 
```

### more things 

```
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  run -tid  --name ashux2 -v ashuvol1:/opt/d1:ro  ubuntu 
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
d19f32bd9e41: Already exists 
Digest: sha256:34fea4f31bf187bc915536831fd0afc9d214755bf700b5cdb1336c82516d154e
Status: Downloaded newer image for ubuntu:latest
b6f9c52c6dc8fc3dbc3d93e5a96c360075f6ef354fba1839f1bfb5e32fdb9499
[ashu@ip-172-31-27-51 ashucustomer1]$ docker  rm  ashux2  ashut1007 -f
ashux2
ashut1007
[ashu@ip-172-31-27-51 ashucustomer1]$ docker volume rm ashuvol1 
ashuvol1
[ashu@ip-172-31-27-51 ashucustomer1]$ 
```

