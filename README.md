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
