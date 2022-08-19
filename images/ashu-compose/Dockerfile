FROM oraclelinux:8.4 
LABEL name="ashutoshh"
LABEL email="ashutoshh@linux.com"
RUN yum install httpd -y 
ADD sample-web-project  /var/www/html/
# COpy and add both are same while add can take input
# from URL also 
CMD ["httpd","-D","FOREGROUND"]
# ENTRYPOINT 
