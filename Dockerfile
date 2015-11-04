FROM phusion/baseimage:0.9.17
MAINTAINER Gianpaolo Macario <gmacario@gmail.com>

# Enable SSH server
RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
#
# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install adduser

# Create user "vagrant", default password: "vagrant"
RUN adduser --gecos "Vagrant pseudo-user" --disabled-password vagrant
RUN usermod -p $(perl -e 'print crypt("vagrant","\$6\$xx\$")') vagrant

# Allow user "vagrant" to become root without entering a password
ADD image /bd_build
RUN install -m 440 /bd_build/etc_sudoers.d_vagrant /etc/sudoers.d/vagrant

# FIXME: Should do this at runtime
RUN mkdir -p /home/vagrant/.ssh && \
	cat /etc/insecure_key.pub >>/home/vagrant/.ssh/authorized_keys && \
	chmod 700 /home/vagrant/.ssh && chown -R vagrant.vagrant /home/vagrant/.ssh

# Create mountpoint for Vagrant synced folder
RUN mkdir -p /vagrant

# EOF
