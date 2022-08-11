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

