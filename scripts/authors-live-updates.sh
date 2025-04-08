#!/bin/bash

INTERVAL=$1

trap 'popd >> /dev/null' EXIT

pushd "$(pwd)" >> /dev/null
cd "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

watch -n ${INTERVAL:-5} ./deploy-content.sh deploy-all