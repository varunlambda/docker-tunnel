FROM ubuntu
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget unzip
RUN wget https://downloads.lambdatest.com/tunnel/linux/64bit/ltcomponent.zip && \ 
    unzip ltcomponent.zip && \
    rm ltcomponent.zip && \
    mv /ltcomponent /LT && \
    chmod +x /LT
 
ENTRYPOINT [ "/LT" ]

