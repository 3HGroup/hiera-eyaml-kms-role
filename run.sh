#!/bin/bash

DIR=$(pwd)

docker run -it --privileged --rm \
-v $DIR:/app \
-v ~/.aws:/root/.aws \
-v ~/.ssh:/root/.ssh \
hiera-eyaml-kms
