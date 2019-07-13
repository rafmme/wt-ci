
#!/usr/bin/env bash

set -e pipefail

source .env

WKDIR=$(pwd)

function reserve_ip() {
    cd tf
    terraform init
    terraform plan -out=tfplan -lock=false
    terraform apply -auto-approve -lock=false
}

function launch_test_cluster() {
    cd $WKDIR/iac/terraform_scripts
    echo ${TERRAFORM_VARS} > gke/variables.tf
    
    # To initialize terraform in the working directory.
    terraform init
    terraform workspace new staging
    terraform plan -out=tfplan -lock=false
    terraform apply -auto-approve -lock=false

    terraform workspace new production
    terraform plan -out=tfplan -lock=false
    terraform apply -auto-approve -lock=false
}

function main () {
    reserve_ip
    launch_test_cluster
}


main
