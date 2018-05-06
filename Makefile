
#
# Ubuntu 18.04 (Bionic Beaver)
#
# Basic packages i usually install.
#
# Author: Janek Thomas
#
# Adapted from: https://gist.github.com/h4cc/c54d3944cb555f32ffdf25a5fa1f2602

.PHONY:	update upgrade preparations graphics fonts google_chrome python slack telegram media latex teamviewer sublime java tools enpass rstudio bash-it

all:
	@echo "Installation of ALL targets"
	make preparations
	make upgrade
	make graphics
	make fonts
	make google_chrome
	make python
	make slack
	make telegram
	make media
	make latex
	make teamviewer
	make sublime
	make java
	make tools
	make enpass
	make rstudio
	make bash-it
	make R

update:
	sudo apt update

upgrade:
	sudo apt -y upgrade

preparations:
	make update
	sudo apt -y install software-properties-common build-essential checkinstall wget curl git libssl-dev apt-transport-https ca-certificates

graphics:
	sudo add-apt-repository ppa:graphics-drivers/ppa
	make update
	sudo apt install nvidia-390

fonts: rstudio bash-it
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
	sudo -H apt -y install python-pip
	sudo -H pip install --upgrade pip

slack:
	sudo snap install slack

telegram:
	#FIXME: snap install should be better but doesn't work currently
	wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
	sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop

media:
	sudo snap install spotify
	sudo apt -y install vlc

latex:
	sudo apt -y install pandoc pandoc-citeproc texlive texlive-latex-extra texlive-latex-base texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra texlive-lang-german texlive-xetex preview-latex-style dvipng nbibtex

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
	sudo apt -y install meld tmux vim

enpass:
	echo "deb http://repo.sinew.in/ stable main" > /etc/apt/sources.list.d/enpass.list
	wget -O - https://dl.sinew.in/keys/enpass-linux.key | apt-key add -
	make update
	sudo apt -y install enpass

rstudio:
	rm -f rstudio-xenial-1.1.447-amd64.deb
	wget https://download1.rstudio.org/rstudio-xenial-1.1.447-amd64.deb
	sudo apt -y install libjpeg62
	sudo dpkg -i rstudio-xenial-1.1.447-amd64.deb
	rm -f rstudio-xenial-1.1.447-amd64.deb

R:
	# R 3.5 does not have a PPA yet
	exit 1

bash-it:
	git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
	~/.bash_it/install.sh

links:
	rm ~/.bashrc
	ln -s ~/dotfiles/.bashrc ~/.bashrc
	rm ~/.ssh/config
	ln -s ~/dotfiles/.ssh/config ~/.ssh/config
	rm ~/.tmux.conf
	ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
