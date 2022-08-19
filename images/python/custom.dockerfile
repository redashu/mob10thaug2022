FROM oraclelinux:8.4 
# using base image 
LABEL email=ashutoshh@linux.com 
RUN yum install python3 -y 
RUN mkdir /code 
COPY hello.py  /code/
CMD ["python3","/code/hello.py"]
