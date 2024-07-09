#region one-time setup
# so that pwsh will run !!
sudo chmod +x /usr/local/bin/pwsh

sudo add-apt-repository universe
sudo apt-get update
sudo apt install python3-pip
python3 -m pip install pyjwt

# pwsh
pwsh
Set-PSResourceRepository -Name PSGallery -Trusted
Install-PSResource Az.Resources,Az.Automation

# enable feature on sub

az feature register --namespace "Microsoft.Compute" --name "EncryptionAtHost"
az feature show --namespace "Microsoft.Compute" --name "EncryptionAtHost"

#endregion

bash

#region create spn - one time
<#
# Log out of Azure and clear cached credentials (skip if using cloudshell)
az logout

# Clear cached credentials (skip if using cloudshell)
az account clear

# Log into Azure (skip if using cloudshell)
az login
#>

az login --tenant add02cc8-7eaf-4746-902a-53d0ceeff326

# Replace 00000000-0000-0000-0000-000000000000 with the subscription id
az ad sp create-for-rbac -n BeardSandboxSPN --role Contributor --scopes /subscriptions/6d8f994c-9051-4cef-ba61-528bab27d213
#endregion

#region set up vnet shared first
# log in to Azure
az login --tenant add02cc8-7eaf-4746-902a-53d0ceeff326

# Change the current directory to the correct configuration

cd /workspaces/azuresandbox/terraform-azurerm-vnet-shared

# Find and copy the Subscription Id to be used for the configurations.

az account list -o table

#Set the default Azure subscription using the Subscription Id from the previous step.

az account set -s 6d8f994c-9051-4cef-ba61-528bab27d213

# Add an environment variable containing the password for your service principal.

export TF_VAR_arm_client_secret=  FROM THE CREDS

<# bootstrap file instructions
    FILE MUST BE UTF-BOM AND LF line endings
    Run bootstrap.sh using the default settings or your own custom settings.

    ./bootstrap.sh
    When prompted for arm_client_id, use the appId for the service principal created by the subscription owner.
    When prompted for resource_group_name use a custom value if there are other sandbox users using the same subscription.
    When prompted for adminuser, the default is bootstrapadmin.
    Important: If you use a custom value, avoid using restricted usernames.
    When prompted for skip_admin_password_gen, accept the default which is no.
    Important: A strong password will be generated for you and stored in the adminpassword key vault secret.
    When prompted for skip_storage_kerb_key_gen, accept the default which is no.
    Important: A secret generated for you and stored in the STORAGE-ACCOUNT-kerb1 key vault secret.
    #>
./bootstrap.sh

# Initialize providers
terraform init

# Check configuration for syntax errors
terraform validate

# Review plan output
terraform plan

# Apply plan
terraform apply

#endregion