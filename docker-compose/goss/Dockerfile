FROM aelsabbahy/goss:latest

LABEL maintainer="miklos.szel@edmodo.com"

WORKDIR /goss/

ENTRYPOINT ["goss", "--vars", "/goss/vars.yaml", "serve", "-f", "documentation", "-o", "verbose",  "-e", "/"]
