FROM ubuntu:jammy

RUN apt update
RUN apt install -y curl git jq libssl-dev

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
