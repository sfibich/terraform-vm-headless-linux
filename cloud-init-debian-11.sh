#!/bin/bash
############################
# Target:Debian 11         #
############################
sleep 20

user_name=adminuser

############################
# start cloud init         #
############################

sudo timedatectl set-timezone America/New_York
sudo touch /tmp/cloud-init.log
sudo chmod a+w /tmp/cloud-init.log
echo "cloud init start" >> /tmp/cloud-init.log
date >> /tmp/cloud-init.log
cd /home/$user_name
mkdir installs
echo "complete: home setup" >> /tmp/cloud-init.log
sudo apt-get update -y 
sudo apt-get upgrade -y 
echo "complete: update & upgrade" >> /tmp/cloud-init.log

############################
# Tools		               #
############################
sudo apt-get install gnupg2 -y
sudo apt-get install software-properties-common -y
sudo apt-get install cmake -y
sudo apt-get install python3.9-dev -y
sudo apt-get install build-essential -y
sudo apt-get install vim-nox -y
sudo apt-get install tree -y
sudo apt-get install tmux -y
sudo apt-get install htop -y
sudo apt-get install git -y
curl -fLo /home/$user_name/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo chown -R $user_name:$user_name .vim

echo "complete: tools" >> /tmp/cloud-init.log

############################
# Terraform                #
############################
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update 
sudo apt-get install terraform -y
echo "complete: terraform" >> /tmp/cloud-init.log

############################
# java                     #
############################
sudo apt-get install default-jdk -y 
echo "complete: java" >> /tmp/cloud-init.log


############################
# Install Powershell       #
############################
# Download the Microsoft repository GPG keys
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
mv packages-microsoft-prod.deb installs/packages-microsoft-prod.deb

# Register the Microsoft Product feed (Not in MS repo for Bullseye, had to use buster)
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-buster-prod buster main" > /etc/apt/sources.list.d/microsoft.list'

# Update the list of products
sudo apt-get update

# Install PowerShell
sudo apt-get install -y powershell
echo "complete: powershell" >> /tmp/cloud-init.log


############################
# PowerShell AZ            #
############################
#pwsh -command "Install-Module -Name Az -AllowClobber -Scope CurrentUser -Force"
#echo "complete: powershell modules" >> /tmp/cloud-init.log


############################
# Install AZ Cli           #
############################
sudo apt-get update -y  
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg  -y 
echo "Download and install the Microsoft signing key" >> /tmp/cloud-init.log
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "Add the Azure CLI software repository" >> /tmp/cloud-init.log
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list 
echo "Update repository information and install the azure-cli package" >> /tmp/cloud-init.log
sudo apt-get update -y 
sudo apt-get install azure-cli -y 
echo "complete:az cli" >> /tmp/cloud-init.log


############################
# Install AZ Func         #
############################
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/debian/$(lsb_release -rs | cut -d'.' -f 1)/prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-get update -y
sudo apt-get  install azure-functions-core-tools-3 -y
echo "complete: az func" >> /tmp/cloud-init.log

############################
# Install core dev utils   #
############################
#sudo apt-get install python3.6-dev -y
#sudo apt-get install python3.8 python3.8-dev python3.8-distutils python3.8-venv -y


############################
# Install Python 3.9	   #
############################
sudo apt-get install python3.9-venv -y
sudo apt-get install python3.9-doc -y


############################
# Work in Progress below   #
############################


############################
# Git Pulls                #
############################
echo "complete: git"
wget https://raw.githubusercontent.com/sfibich/config/master/.vimrc
sudo chown $user_name:$user_name .vimrc
echo "complete: shellStation" >> /tmp/cloud-init.log

############################
# finish cloud init        #
############################
sudo chown -R $user_name:$user_name installs
sudo apt-get autoremove -y 

echo "complete: cloud init finish" >> /tmp/cloud-init.log
echo "check /var/log/apt/history.log for apt-get log info" >> /tmp/cloud-init.log
date >> /tmp/cloud-init.log
