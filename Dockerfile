FROM debian:buster-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
 apt-get install \
 build-essential \
 git \
 python3 \
 python3-pip \
 python3-setuptools \
 python3-wheel \
 ruby \
 ruby-bundler \
 ruby-dev \
 --no-install-recommends -qq -y

 RUN pip3 install awscli

WORKDIR /app

COPY Gemfile .
COPY *.gemspec ./

RUN bundle install

ENTRYPOINT [ "/bin/bash" ]
