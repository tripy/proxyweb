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
RUN /usr/local/bin/dbdeployer deploy replication 5.7.26  -n 4 --gtid  --read-only-slaves   --my-cnf-options report-host=dbtest --my-cnf-options log_slave_updates --my-cnf-options log_bin --my-cnf-options binlog_format=ROW  --bind-address=0.0.0.0  --remote-access='%' && \
 /usr/local/bin/dbdeployer data-load get world   rsandbox_5_7_26/master && \
 /usr/local/bin/dbdeployer data-load get sakila  rsandbox_5_7_26/master


RUN rm /tmp/*.tar.gz &&  rm -rf /var/lib/apt/lists/*

ENTRYPOINT /root/sandboxes/rsandbox_5_7_26/start_all && /root/sandboxes/rsandbox_5_7_26/use_all_slaves "stop slave;  CHANGE MASTER TO MASTER_HOST='dbtest', MASTER_USER='msandbox', MASTER_PASSWORD='msandbox', MASTER_PORT=19327, MASTER_AUTO_POSITION = 1;  start slave;"  && sleep infinity

