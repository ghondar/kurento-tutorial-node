#!/bin/bash -e

# GUEST IP
GUEST_IP=192.168.100.100

# Hosts files
HOSTS=/etc/hosts

# TODO: change the print usage text
###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your NODEJS environment has been setup and can be accessed on your local machine on the forwarded port (default: 8088)"
  echo "  Host: $GUEST_IP  [ local.kurento-example ]"
  echo "  Guest IP: $GUEST_IP"
  echo "    added:   \"local.kurento-example   $GUEST_IP\"   to /etc/hosts"
  echo ""
  echo ""
  echo "  Getting into the box (terminal):"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo ""
  echo ""
}

export DEBIAN_FRONTEND=noninteractive

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi

chown vagrant /etc/hosts
#echo "192.168.100.100   app.local.worldkite.org" >> "HOSTS"
echo "$GUEST_IP   local.kurento-example" >> /etc/hosts

# update / upgrade
# apt-get update
# apt-get -y upgrade

# install kurento
echo "deb http://ubuntu.kurento.org trusty kms6" | tee /etc/apt/sources.list.d/kurento.list
wget -O - http://ubuntu.kurento.org/kurento.gpg.key | apt-key add -
apt-get update
apt-get -y install kurento-media-server-6.0

# install node v4.3.1 LTS (Long term stable)
#apt-get -y install curl
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
apt-get -y install nodejs

#Install node-inspector package for debugging
sudo npm install -g node-inspector

#Install nodemon for live reload
sudo npm install -g nodemon

# install git
apt-get -y install git

sudo service kurento-media-server-6.0 start

# Tag the provision time:
date > "$PROVISIONED_ON"

echo "Successfully created NODE.JS 5 dev virtual machine."
echo ""
print_db_usage
