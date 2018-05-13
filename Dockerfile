FROM jenkins/jenkins:lts
MAINTAINER danghung
USER root

RUN apt-get update

# instal docker
RUN apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
xenial \
stable"

RUN apt-get update
RUN apt-get install -y docker-ce
# install awscli
RUN apt install awscli -y
RUN apt-get install python3-pip -y
RUN pip3 install --upgrade awscli
# install jq
RUN apt-get install jq -y
# install slack cli
RUN curl -o /bin/slack https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack
RUN chmod +x /bin/slack
# install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN cat <<EOF >/etc/apt/sources.list.d/kubernetes.list \
  deb http://apt.kubernetes.io/ kubernetes-xenial main \
  EOF
RUN apt-get update
RUN apt-get install -y kubectl

# # copy id_rsa, make it work
# COPY id_rsa /root/.ssh/id_rsa
# COPY id_rsa.pub /root/.ssh/id_rsa.pub
# RUN chmod 600 /root/.ssh/id_rsa
# RUN chmod 600 /root/.ssh/id_rsa.pub

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add github (or bitbucket) fingerprint to known hosts
RUN ssh-keyscan -t rsa bitbucket.org github.com gitlab.com >> /root/.ssh/known_hosts
