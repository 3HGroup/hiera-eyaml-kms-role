FROM debian:stretch-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
 apt-get install build-essential git ruby ruby-bundler ruby-dev --no-install-recommends -qq -y

WORKDIR /app

COPY Gemfile .
COPY *.gemspec ./

RUN bundle install

ENTRYPOINT [ "/bin/bash" ]
