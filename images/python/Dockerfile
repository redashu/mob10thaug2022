FROM python
#  docker engine will pull image from Docker hub if not present 
LABEL name=ashutoshh
LABEL email=ashutoshh@linux.com 
# optional field but you can share image Designer info 
RUN mkdir /code 
# is to give shell in container during image build time 
COPY hello.py /code/ 
# to copy data from docker clien to docker server during image build time
CMD ["python","/code/hello.py"]
#  to set default process for container 