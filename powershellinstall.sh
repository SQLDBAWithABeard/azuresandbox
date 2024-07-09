# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Update the list of products
sudo apt-get update
# so that we can run add-apt-repository
sudo apt-get install software-properties-common
# Enable the "universe" repositories
sudo add-apt-repository universe -y
# Install PowerShell
sudo apt-get install -y powershell
# Start PowerShell
pwsh
