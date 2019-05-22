FROM alpine:latest

RUN apk add --no-cache git ruby

WORKDIR /app



#RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories
#RUN apk update
#RUN apk add --no-cache python3 git bash ruby ruby-bundler jq less shadow ruby-json zip docker
#RUN pip3 install --upgrade pip
#RUN pip3 install requests Jinja2 awscli invoke colorlog boto3

#RUN wget https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_linux_amd64.zip -O /tmp/packer.zip
#RUN unzip /tmp/packer.zip -d /tmp && mv /tmp/packer /usr/bin/packer && chmod +x /usr/bin/packer

#WORKDIR /usr/src/helium

#COPY Gemfile* /tmp/

#RUN bundle install --gemfile /tmp/Gemfile

CMD [ "/bin/ash" ]
