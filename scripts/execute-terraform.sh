if [ $# -eq 0 ] then
  echo "No arguments supplied, specify either 'apply' or 'destroy'."
fi

if [ ($1 != "apply") && ($1 != "destroy") ] then
  echo "Invalid argument supplied, specify either 'apply' or 'destroy'."
fi

cd "$CHATBOT170INFRASTRUCTURE_MASTER_RSYNC_STATE"
terraform --version
terraform init
terraform get

if [($1 == 'apply')] then
  terraform apply --auto-approve
fi

if [($1 == 'destroy')] then
  terraform destroy -force
fi
