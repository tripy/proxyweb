FROM ubuntu:20.04

LABEL maintainer="miklos.szel@edmodo.com"


RUN apt-get update -y && \
    apt-get install  --no-install-recommends  wget  ca-certificates jq curl -y

RUN wget  https://github.com/openark/orchestrator/releases/download/v3.2.3/orchestrator-sysv-3.2.3_amd64.deb  -O /tmp/orchestrator_3.2.3_amd64.deb
RUN wget   https://github.com/openark/orchestrator/releases/download/v3.2.3/orchestrator-client_3.2.3_amd64.deb  -O /tmp/orchestrator-client_3.2.3_amd64.deb

RUN dpkg -i /tmp/orchestrator_3.2.3_amd64.deb  /tmp/orchestrator-client_3.2.3_amd64.deb

WORKDIR /usr/local/orchestrator/
COPY entry.sh /
RUN chmod 755 /entry.sh 
COPY orchestrator.conf.json  /etc/orchestrator.conf.json
RUN rm -rf /var/lib/apt/lists/* && rm /tmp/*.deb

ENTRYPOINT [ "/entry.sh" ]



