FROM alpine:3.10
LABEL maintainer="miklos.szel@edmodo.com"

ENV GOSS_VER v0.3.16
ENV PATH=/goss:$PATH
ENV PYTHONUNBUFFERED=1

# Install goss
RUN apk add --no-cache --virtual=goss-dependencies curl ca-certificates && \
    mkdir /goss && \
    curl -fsSL https://goss.rocks/install |  sh && \
    apk del goss-dependencies && \
    apk add --no-cache curl && \
    apk add --update --no-cache python3  && ln -sf python3 /usr/bin/python

WORKDIR /goss/
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools gunicorn

ENTRYPOINT ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "app:app" ]
