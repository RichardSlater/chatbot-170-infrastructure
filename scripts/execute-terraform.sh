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

cd "$CB170_INFRA_MASTER_STATE"
terraform --version

terraform init
terraform get

mkdir -p "$CB170_INFRA_MASTER_STATE/plan"
TF_PLAN="$CB170_INFRA_MASTER_STATE/plan/terraform.tfplan"

TF_APPLY_REQD=0
if [[ $1 == 'apply' ]]
  then
    terraform plan -detailed-exitcode -out="$TF_PLAN"
    TF_APPLY_REQD=$?
fi

if [[ $1 == 'destroy' ]]
  then
    terraform plan -detailed-exitcode -destroy -out="$TF_PLAN"
    TF_APPLY_REQD=$?
fi

if [[ $TF_APPLY_REQD == 1 ]]
  then
    echo "Error occured."
    exit 1
fi

if [[ $TF_APPLY_REQD == 2 ]]
  then
    terraform apply -auto-approve "$TF_PLAN"
fi
