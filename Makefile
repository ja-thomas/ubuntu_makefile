#
# Ubuntu 18.04 (Bionic Beaver)
#
# Basic packages i usually install.
#
# Author: Janek Thomas
#
# Adapted from: https://gist.github.com/h4cc/c54d3944cb555f32ffdf25a5fa1f2602

.PHONY:	update upgrade preparations graphics fonts google_chrome python slack telegram media latex teamviewer sublime java tools enpass rstudio bash-it ssh-key docker

all:
	@echo "Installation of ALL targets"
	make update
	make upgrade
	make preparations
	make tools
	make fonts
	make graphics
	make dropbox
	make enpass
	make google_chrome
	make python
	make slack
	make telegram
	make media
	make latex
	make teamviewer
	make sublime
	make java
	make enpass
	make rstudio
	make bash-it
	make R
	make impressive
	make docker
	make bat

update:
	sudo apt update

upgrade:
	sudo apt -y upgrade

preparations:
	make update
	sudo apt -y install software-properties-common build-essential checkinstall wget curl git libssl-dev apt-transport-https ca-certificates libcurl4-openssl-dev libxml2-dev libcairo2-dev libgmp3-dev libproj-dev libcgal-dev libglu1-mesa-dev libx11-dev libgsl-dev libcr-dev mpich mpich-doc

dropbox:
	sudo apt -y install nautilus-dropbox
	nautilus --quit
	dropbox start -i

graphics:
	sudo add-apt-repository ppa:graphics-drivers/ppa
	make update
	sudo apt install nvidia-390

fonts:
	mkdir -p ~/.fonts
	rm -f ~/.fonts/*
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf -O ~/.fonts/Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete.otf
	fc-cache -v

google_chrome:
	rm -f google-chrome-stable_current_amd64.deb
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt -y install libappindicator1 libindicator7
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	rm -f google-chrome-stable_current_amd64.deb

python:
	make preparations
	sudo apt -y install python3-pip
	sudo apt -y install ipython3
	sudo pip3 install --upgrade pip
	pip3 install --user flake8

slack:
	sudo snap install slack --classic

telegram:
	#FIXME: snap install should be better but doesn't work currently
	wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
	sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop

media:
	sudo snap install spotify
	sudo apt -y install vlc

latex:
	sudo apt -y install pandoc pandoc-citeproc texlive-full dvipng nbibtex

teamviewer:
	sudo apt -y install qml-module-qtquick-dialogs qml-module-qtquick-privatewidgets libqt5webkit5
	rm -f teamviewer_amd64.deb
	wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
	sudo dpkg -i teamviewer_amd64.deb
	rm -f teamviewer_amd64.deb

sublime:
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt-add-repository "deb https://download.sublimetext.com/ apt/stable/"
	make update
	sudo apt -y install sublime-text

java:
	#FIXME: Do I need oracle jdk or is open enough?
	sudo apt -y install default-jre default-jdk

tools:
	sudo apt -y install meld tmux vim gnome-tweak-tool

enpass:
	echo "deb http://repo.sinew.in/ stable main" | sudo tee -a /etc/apt/sources.list.d/enpass.list
	wget -O - https://dl.sinew.in/keys/enpass-linux.key | sudo apt-key add -
	make update
	exit
	sudo apt -y install enpass

rstudio:
	rm -f rstudio-xenial-1.1.447-amd64.deb
	wget https://download1.rstudio.org/rstudio-xenial-1.1.447-amd64.deb
	sudo apt -y install libjpeg62
	sudo dpkg -i rstudio-xenial-1.1.447-amd64.deb
	rm -f rstudio-xenial-1.1.447-amd64.deb

R:
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
	sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/'
	sudo apt -y install r-base r-base-dev
	mkdir -p ~/.R/library
	Rscript -e "install.packages(c('devtools', 'colorout'))"
	Rscript -e "library(devtools); install_github('rdatsci/rt', 'jalvesaq/colorout')"
	rt init

impressive:
	sudo apt -y install python-opengl python-pygame python-pil
	wget https://sourceforge.net/projects/impressive/files/Impressive/0.12.0/Impressive-0.12.0.tar.gz
	sudo tar -xf Impressive-0.12.0.tar.gz -C /opt
	rm Impressive-0.12.0.tar.gz
	sudo ln -s /opt/Impressive-0.12.0/impressive.py /usr/bin/imp

bash-it:
	git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
	~/.bash_it/install.sh

ssh-key:
	ssh-keygen -t rsa -b 4096 -C "janek.thomas@web.de"
	ssh-add ~/.ssh/id_rsa

links:
	ln -fs ~/dotfiles/.bashrc ~/.bashrc
	ln -fs ~/dotfiles/.ssh/config ~/.ssh/config
	ln -fs ~/dotfiles/.tmux.conf ~/.tmux.conf
	ln -fs ~/dotfiles/.Renviron ~/.Renviron
	ln -fs ~/dotfiles/.Rprofile ~/.Rprofile
	ln -fs ~/dotfiles/.vimrc ~/.vimrc
	ln -fs ~/dotfiles/.gitconfig ~/.gitconfig
	ln -fs ~/dotfiles/.openml ~/.openml
	ln -fs ~/dotfiles/.ipython/profile_default/ipython_config.py ~/.ipython/profile_default/ipython_config.py
	ln -fs ~/dotfiles/bin ~/bin
	ln -fs ~/dotfiles/.rt/packages ~/.rt/packages

sublime-links:
	ln -fs ~/dotfiles/sublime/Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
	ln -fs ~/dotfiles/sublime/Python.sublime-settings ~/.config/sublime-text-3/Packages/User/Python.sublime-settings
	ln -fs ~/dotfiles/sublime/Default\ \(Linux\).sublime-keymap ~/.config/sublime-text-3/Packages/User/Default\ \(Linux\).sublime-keymap
	ln -fs ~/dotfiles/sublime/SendCode\ \(Linux\).sublime-settings ~/.config/sublime-text-3/Packages/SendCode/SendCode\ \(Linux\).sublime-settings
	ln -fs ~/dotfiles/sublime/SublimeLinter.sublime-settings ~/.config/sublime-text-3/Packages/User/SublimeLinter.sublime-settings


docker:
	sudo apt-get install apt-transport-https ca-certificates software-properties-common
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
	make update
	sudo apt-get install docker-ce
	sudo groupadd docker
	sudo usermod -aG docker $USER
	sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose

bat:
	wget https://github.com/sharkdp/bat/releases/download/v0.6.0/bat_0.6.0_amd64.deb
	sudo dpkg -i bat_0.6.0_amd64.deb
	rm bat_0.6.0_amd64.deb
