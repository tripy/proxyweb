FROM alpine:3.10
LABEL maintainer="miklos.szel@edmodo.com"

ENV GOSS_VER v0.3.16
ENV PATH=/goss:$PATH
ENV PYTHONUNBUFFERED=1

# Install goss
RUN apk add --no-cache  curl ca-certificates python3 mysql-client bash && \
    mkdir /goss && \
    curl -fsSL https://goss.rocks/install |  sh


RUN ln -sf python3 /usr/bin/python

RUN mkdir -p /app
COPY app /app/


WORKDIR /app/

RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip -r requirements.txt


ENTRYPOINT ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "app:app" ]
