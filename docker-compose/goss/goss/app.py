#!/usr/bin/python3
import os

def app(environ, start_response):
        stream = os.popen('goss  --vars /goss/vars.yaml  -g /goss/goss.yaml validate -f rspecish   -o pretty')
        output = stream.read()
        start_response("200 OK", [
            ("Content-Type", "text/plain"),
            ("Content-Length", str(len(output)))
        ])
        return [bytes(output, 'utf-8')]
