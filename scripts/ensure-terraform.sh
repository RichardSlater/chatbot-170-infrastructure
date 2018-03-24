TF_TARGET_VERSION=$1

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 0
fi

if hash terraform 2>/dev/null; then
  TF_CURR_VERSION=$(terraform --version | sed 's/[^0-9.]*\([0-9.]*\).*/\1/')
fi

if [ "$TF_CURR_VERSION" == "$TF_TARGET_VERSION" ]
  then
    echo "Up-to-date"
    exit 0
fi

TF_FILE=terraform_"$TF_TARGET_VERSION"_linux_amd64.zip
mkdir -p /tmp/terraform
wget -nv https://releases.hashicorp.com/terraform/$TF_TARGET_VERSION/$TF_FILE
unzip -o $TF_FILE -d /tmp/terraform
sudo chmod +x /tmp/terraform/terraform
mv /tmp/terraform/terraform /usr/bin/terraform
terraform --version
