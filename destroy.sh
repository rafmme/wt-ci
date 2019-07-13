#!/usr/bin/env bash

set -e pipefail

source .env

WKDIR=$(pwd)

function destroy() {
    cd tf
    terraform destroy -auto-approve -lock=false

    cd $WKDIR/iac
    terraform destroy -auto-approve -lock=false
}

function main () {
    destroy
}


main
