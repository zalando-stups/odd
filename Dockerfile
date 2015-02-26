FROM zalando/openjdk:8u40-b09-2
MAINTAINER Henning Jacobs <henning.jacobs@zalando.de>

RUN apt-get update -y
RUN apt-get install -y supervisor openssh-server python-setuptools python3-requests python3-yaml

RUN mkdir -p -m0755 /var/run/sshd

COPY supervisord.conf /etc/supervisord.conf
COPY sshd_config /etc/ssh/sshd_config

EXPOSE 22

CMD /usr/bin/supervisord -c /etc/supervisord.conf
