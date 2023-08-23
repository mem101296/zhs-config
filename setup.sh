#!/bin/sh

OMZDIR=~/.oh-my-zsh
p10kf=~/.p10k.zsh
GIT=~/git
MFILES=~/git/zsh-config

#############################################
#functions
#############################################
#Checks OS type and calls correct functions
os_check (){
    if [[ $osType == "arch" || $osType == "Arch" ]];then
        arch_check
    fi
    if [[ $osType == "debian" || $osType == "Debian" ]];then
        debain_check
    fi
}
#############################################
debain_check () {
    zsh_check_debain
    check=$?
    echo $check
    if [[ $check == 0 ]];then
        echo "ZSH is installed"
    else
        zsh_check_debain
        wait
    fi

    oh_my_zsh_check
    check=$?
    echo $check
    if [[ $check == 0 ]];then
        echo "Oh-my-zsh is installed"
    else
        oh_my_zsh_install
        wait
    fi

    pl10k_check
    check=$?
    echo $check
    if [[ $check == 0 ]];then
        echo "Powerlevel10k is installed"
    else
        pl10k_install
        wait
    fi

}
#############################################
arch_check () {
    
    zsh_check_arch
    check=$?
    echo $check
    if [[ $check == 0 ]];then
        echo "ZSH is installed"
    else
        zsh_check_arch
        wait
    fi

    oh_my_zsh_check
    check=$?
    echo $check
    if [[ $check == 0 ]];then
        echo "Oh-my-zsh is installed"
    else
        oh_my_zsh_install
        wait
    fi

    pl10k_check
    check=$?
    echo $check
    if [[ $check == 0 ]];then
        echo "Powerlevel10k is installed"
    else
        pl10k_install
        wait
    fi
}
#############################################
#Checks for git directory
git_check () {
    if [[ -d $GIT ]]; then
        return 0
    else
        return 1
    fi
}
#############################################
#Creates git directory
git_create () {
    cd ~
    mkdir git
}
#############################################
#Checks for ZSH package in arh
zsh_check_arch () {
    ZSHCHECK=`pacman -Q | grep "zsh"`

    if [[ $ZSHCHECK == *"zsh"* ]]; then
        return 0
    else
        return 1
    fi
}
#############################################
#Checks for ZSH package in arh
zsh_check_debain () {
    ZSHCHECK=`apt list --installed | grep "zsh"`

    if [[ $ZSHCHECK == *"zsh"* ]]; then
        return 0
    else
        return 1
    fi
}
#############################################
#Checks for ZSH package in arch
zsh_install_arch() {
    echo "ZSH is not installed... installing"
    sudo pacman -S zsh -y
}
#############################################
#Installs ZSH package in debian
zsh_install_debian() {
    echo "ZSH is not installed... installing"
    sudo apt install zsh -y
}
#############################################
#Checks for oh_my_zsh
oh_my_zsh_check () {
    if [[ -d $OMZDIR ]];then 
        return 0
    else
        return 1
    fi
}
#############################################
#Installs oh_my_zsh
oh_my_zsh_install () {
    git_check
    check=$?
    echo $check
    if [[ $check == 0 ]];then
        echo ""
    else
        echo "creating a git directory for install files"
        git_create
        wait
    fi

    echo "Putting install files in your git directory"
    cd ~/git
    echo "Oh-my-zsh  is not installed... installing"
    curl -L http://install.ohmyz.sh | sh
}
#############################################
#Powerlevel10k Check
pl10k_check () {
    if [[ -f $p10kf ]];then 
        return 0
    else
        return 1
    fi
}
#############################################
#Powerlevel10k Install
pl10k_install () {
    git_check
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/git/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
}
#############################################
#Asking if want mikes files
mikes_file_prompt () {
    read -p "Would you like to install my config files for oh-my-zsh and Powerlevel10k? (Y/N): " mchoice
    case $mchoice in
        [yY]*)
            echo "Installing"
            mikes_files_install
            break
            ;;
        [nN]*)
            echo "Ok, closing the program"
            closing
            break
            ;;
        *)
            echo "Invalid Input" >&2
    esac
done
}
#############################################
#Checking if Mikes files exist
mikes_file_check () {
    if [[ -d $MFILES ]];then 
        return 0
    else
        return 1
    fi
}
#############################################
#Installing Mikes fies
mikes_files_install () {
    git_check
    mikes_file_check
    check=$?
    echo $check
    if [[ $check == 0 ]];then
        cd ~/git/zsh-config
        cp .pk10k.zsh ~/.pk10.zsk
        wait
        cp .zshrc ~/.zshrc
        wait
        cp -r .oh-my-zsh ~/.oh-my-zsh
        wait
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/plugins
    else
        git clone git@github.com:mem101296/zsh-config.git ~/git/zsh-config
        cd ~/git/zsh-config
        cp .pk10k.zsh ~/.pk10.zsk
        wait
        cp .zshrc ~/.zshrc
        wait
        tar -xf .oh-my-zsh.tar.zx
        cp -r .oh-my-zsh ~/.oh-my-zsh
        wait
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/plugins
    fi
}
#############################################
#Closing the program
closing () {
    echo "closing the program" 
    exit 1
}
#############################################
#End of Functions
#############################################
#grab OS type for the next step
echo "Please choose which OS you have"
while true;do
    read -p "Type \"arch\" or \"debian\": " osType
    case $osType in
        "arch" | "Arch")
            echo $osType
            break
            ;;
        "debian" | "Debian")
            echo $osType
            break
            ;;
        *)
            echo "Invalid Input" >&2
    esac
done
#############################################
#Checks for packages
while true; do
    echo "-----------------------------------------------------"
    echo
    read -p "Do you need zsh, oh-my-zsh, and powerlevel10k them installed? (Y/N): " confirm
    case $confirm in
        [yY]*)
            break
            ;;
        [nN]*)
            break
            ;;
        *)
            echo "Invalid Input" >&2
    esac
done
#############################################
echo
echo "-----------------------------------------------------"

if [[ $confirm == "n" || $confirm == "N" ]]; then
    echo "Double checking that required programs are installed..."
    echo
    os_check
    mikes_file_prompt
else
    echo "Checking for clean install locations"
    echo
    os_check
fi