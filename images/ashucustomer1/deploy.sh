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