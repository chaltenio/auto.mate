# ansible_desktop
Ansible configuration for personal laptops and desktops.
Version 1.0.0

## After you install Ubuntu:

### update OS
```sh
sudo apt update
```

### install Git
```sh
sudo apt install git
```
### install Ansible
```sh
sudo apt install ansible
```
### setup default email and user in git.
```sh
git config --global user.email "youremail@yoursite.com"
git config --global user.name "Your Name"
```
### create SSH Keys if you don't have one.
```sh
ssh-keygen -t ed25519 -C "your_comments"
```
### setup your public key in Github

### clone the project if you would like to make changes
```sh
mkdir ~/dev
cd ~/dev/
git clone git@github.com:chaltenio/ansible_desktop.git
```
### run ansible-pull to execute the playbooks
```sh
sudo ansible-pull -U https://github.com/chaltenio/ansible_desktop.git
```

Enjoy!