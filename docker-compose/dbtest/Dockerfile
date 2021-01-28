FROM ubuntu:20.04

LABEL maintainer="miklos.szel@edmodo.com"

WORKDIR /root/
RUN chmod 777 /tmp
RUN mkdir -p /root/opt/mysql

RUN apt-get update -y && \
    apt-get install --no-install-recommends wget   ca-certificates  mysql-client libncurses5  libaio1  libnuma1 less -y


RUN wget https://github.com/datacharmer/dbdeployer/releases/download/v1.58.2/dbdeployer-1.58.2.linux.tar.gz -O /tmp/dbdeployer-1.58.2.linux.tar.gz
RUN tar -xzf /tmp/dbdeployer-1.58.2.linux.tar.gz
RUN chmod +x dbdeployer-1.58.2.linux
RUN mv dbdeployer-1.58.2.linux /usr/local/bin/dbdeployer
RUN /usr/local/bin/dbdeployer  downloads get-unpack mysql-5.7.26.tar.xz
RUN /usr/local/bin/dbdeployer deploy replication 5.7.26  --bind-address=0.0.0.0  --remote-access='%' && \
 /usr/local/bin/dbdeployer data-load get world   rsandbox_5_7_26/master && \
 /usr/local/bin/dbdeployer data-load get sakila  rsandbox_5_7_26/master
RUN echo "read_only=on" >>/root/sandboxes/rsandbox_5_7_26/node1/my.sandbox.cnf
RUN echo "read_only=on" >>/root/sandboxes/rsandbox_5_7_26/node2/my.sandbox.cnf


RUN rm /tmp/*.tar.gz &&  rm -rf /var/lib/apt/lists/*

ENTRYPOINT /root/sandboxes/rsandbox_5_7_26/start_all && sleep infinity

