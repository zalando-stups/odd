FROM registry.opensource.zalan.do/stups/ubuntu:latest
LABEL maintainer="team-teapot@zalando.de"

RUN apt-get update -y && apt-get install -y supervisor openssh-server psmisc python3-pip sudo netcat syslog-ng
COPY install_eic.sh /install_eic.sh
RUN /install_eic.sh && rm -f /install_eic.sh

COPY requirements.txt /
RUN pip3 install -r /requirements.txt

RUN rm -f /etc/update-motd.d/*
COPY update-motd /etc/update-motd.d/00-bastion
RUN sed -i '/pam_systemd/d' /etc/pam.d/common-session
RUN bash /etc/update-motd.d/00-bastion > /etc/motd
RUN rm -f /run/motd.dynamic
RUN rm -f /etc/legal

RUN mkdir -p -m0755 /var/run/sshd

COPY supervisord.conf /etc/supervisord.conf
COPY sshd_config /etc/ssh/sshd_config
COPY sudoers /etc/sudoers
COPY run.sh /run.sh

# setup SSH Access Granting Service
RUN curl -o /usr/local/bin/grant-ssh-access-forced-command.py \
    https://raw.githubusercontent.com/zalando-stups/even/master/grant-ssh-access-forced-command.py?2
RUN chmod +x /usr/local/bin/grant-ssh-access-forced-command.py
RUN useradd --create-home --user-group --groups adm granting-service
RUN mkdir ~granting-service/.ssh/
RUN echo 'PLACEHOLDER' > ~granting-service/.ssh/authorized_keys
RUN chown granting-service:root -R ~granting-service
RUN chmod 0700 ~granting-service
RUN chmod 0700 ~granting-service/.ssh
RUN chmod 0400 ~granting-service/.ssh/authorized_keys

COPY syslog-ng.conf /etc/syslog-ng.conf

RUN adduser --system --disabled-login --shell /usr/sbin/nologin --no-create-home --home /nonexistent --quiet ec2-instance-connect
RUN adduser --home /home/odd --gecos ",,," --quiet --disabled-password odd

EXPOSE 22

CMD ["/run.sh"]

RUN purge.sh
