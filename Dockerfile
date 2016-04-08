FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y python
RUN echo "deb http://ubuntu.kurento.org trusty kms6" | tee /etc/apt/sources.list.d/kurento.list
RUN wget -O - http://ubuntu.kurento.org/kurento.gpg.key | apt-key add -
RUN apt-get update
RUN apt-get -y install kurento-media-server-6.0
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN apt-get -y install nodejs
RUN sudo npm install -g gyp
RUN sudo npm install -g node-inspector
RUN sudo npm install -g nodemon
RUN apt-get -y install git
RUN sudo service kurento-media-server-6.0 start
EXPOSE 8000