#!/bin/bash

DIR=$(pwd)

docker run -it --rm \
-v $DIR:/app \
-v ~/.aws:/root/.aws \
hiera-eyaml-kms
