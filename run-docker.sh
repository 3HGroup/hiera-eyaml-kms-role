#!/bin/bash

DIR=$(pwd)

docker run -it --rm \
-v $DIR:/app \
-v ~/.ssh:/root/.ssh \
hiera-eyaml-kms
