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