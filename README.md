## Docker and kubernetes 

### getting started with ci tool jenkins 

```
 484  cd  ashumobiwebapp/
  485  ls
  486  git clone https://github.com/redashu/mobiwebapp.git
  487  ls
  488  cp -v docker-compose.yaml   mobiwebapp/
  489  cp -v Dockerfile   mobiwebapp/
  490  cp -v index.html   mobiwebapp/
  491  cp -v docker.png   mobiwebapp/
  492  cp -v .dockerignore  mobiwebapp/

```

### adding code to git repo with commit 

```
495  cd  mobiwebapp/
  496  ls  -a
  497  git  add  . 
  498  git commit -m  "first change to app "
  499  git config --global user.email ashutoshh@linux.com
  500  git config --global user.name  redashu
  501  history 
[ashu@ip-172-31-27-51 mobiwebapp]$ git commit -m  "first change to app "
[master 803e4c9] first change to app
 5 files changed, 31 insertions(+)
 create mode 100644 .dockerignore
 create mode 100644 Dockerfile
 create mode 100644 docker-compose.yaml
 create mode 100644 docker.png
 create mode 100644 index.html
```

### git push code 

```
[ashu@ip-172-31-27-51 mobiwebapp]$ git push origin master  
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 8 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (7/7), 3.60 KiB | 3.60 MiB/s, done.
Total 7 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/redashu/mobiwebapp.git
   6499085..803e4c9  master -> master
[ashu@ip-172-31-27-51 mobiwebapp]$ 
```





