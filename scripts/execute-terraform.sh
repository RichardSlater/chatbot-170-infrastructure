#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, specify either 'apply' or 'destroy'."
    exit 1
fi

if [[ "$1" != "apply" && "$1" != "destroy" ]]
  then
    echo "Invalid argument supplied, specify either 'apply' or 'destroy'."
    exit 1
fi

cd "$GITHUB_CB170_INFRA_MASTER_STATE"
terraform --version

terraform init
terraform get

mkdir -p "$GITHUB_CB170_INFRA_MASTER_STATE/plan"
TF_PLAN="$GITHUB_CB170_INFRA_MASTER_STATE/plan/terraform.tfplan"

if [[ $1 == 'apply' ]]
  then
    terraform plan -out="$TF_PLAN"
fi

if [[ $1 == 'destroy' ]]
  then
    terraform plan -destroy -out="$TF_PLAN"
fi

terraform apply -auto-approve "$TF_PLAN"
