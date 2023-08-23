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
#Checks made for debian based Linux systems
debain_check () {
    echo $waterMarkOS
    echo "Debian"
    zsh_check_debain
    check=$?
    if [[ $check == 0 ]];then
        echo "--------------------"
        echo "| ZSH is installed |"
    else
        zsh_check_debain
        wait
    fi

    oh_my_zsh_check
    check=$?
    if [[ $check == 0 ]];then
        echo "--------------------------"
        echo "| Oh-my-zsh is installed |"
    else
        oh_my_zsh_install
        wait
    fi

    pl10k_check
    check=$?
    if [[ $check == 0 ]];then
        echo "------------------------------"
        echo "| Powerlevel10k is installed |"
        echo "------------------------------"
    else
        pl10k_install
        wait
    fi

}
#############################################
#Checks made for arch based linux systems
arch_check () {
    echo $waterMarkOS
    zsh_check_arch
    check=$?
    if [[ $check == 0 ]];then
        echo "--------------------"
        echo "| ZSH is installed |"
    else
        zsh_check_arch
        wait
    fi

    oh_my_zsh_check
    check=$?
    if [[ $check == 0 ]];then
        echo "--------------------------"
        echo "| Oh-my-zsh is installed |"
    else
        oh_my_zsh_install
        wait
    fi

    pl10k_check
    check=$?
    if [[ $check == 0 ]];then
        echo "------------------------------"
        echo "| Powerlevel10k is installed |"
        echo "------------------------------"
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

    if [[ $ZSHCHECK == *"zsh"* ]]; then #checks if anything has zsh in it
        return 0
    else
        return 1
    fi
}
#############################################
#Checks for ZSH package in arh
zsh_check_debain () {
    ZSHCHECK=`apt list --installed | grep "zsh"`

    if [[ $ZSHCHECK == *"zsh"* ]]; then #checks if anything has zsh in it
        return 0
    else
        return 1
    fi
}
#############################################
#Checks for ZSH package in arch https://wiki.archlinux.org/title/Zsh
zsh_install_arch() {
    echo "--------------------------------------"
    echo "| ZSH is not installed... installing |"
    echo "--------------------------------------"
    sudo pacman -S zsh -y
    wait
}
#############################################
#Installs ZSH package in debian https://wiki.debian.org/Zsh
zsh_install_debian() {
    echo "--------------------------------------"
    echo "| ZSH is not installed... installing |"
    echo "--------------------------------------"
    sudo apt install zsh -y
    wait
    clear
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
#Installs oh_my_zsh https://github.com/ohmyzsh/ohmyzsh
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
#Powerlevel10k Install see https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
pl10k_install () {
    git_check
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/git/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
}
#############################################
#Asking if want mikes files
mikes_file_prompt () {
while true;do
    echo "-------------------------------------------------------------------------------------"
    echo "| Would you like to install my config files for oh-my-zsh and Powerlevel10k? (Y/N): |"
    echo "-------------------------------------------------------------------------------------"
    read -p "> " mchoice
    case $mchoice in
        [yY]*)
            echo "--------------"
            echo "| Installing |"
            echo "--------------"
            mikes_files_install
            break
            ;;
        [nN]*)
            echo "---------------------------"
            echo "| Ok, closing the program |"
            echo "---------------------------"
            closing
            break
            ;;
        *)
            echo "-----------------"
            echo "| Invalid Input |" >&2
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
    clear
    echo $waterMarkOS
    git_check
    mikes_file_check
    check=$?
    if [[ $check == 0 ]];then
        echo "--------------------------"
        echo "| Entering ZSH folder... |"
        cd ~/git/zsh-config
        echo "--------------------------"
        echo "| Copying p10k Config... |"
        echo "--------------------------"
        cp .p10k.zsh ~/.p10k.zsh
        #Used for testing purposes
        #cp .p10k.zsh ~/test/.p10k.zsh
        wait
        echo "| Copying .zshrc... |"
        cp .zshrc ~/.zshrc
        #Used for testing purposes
        #cp .zshrc ~/test/.zshrc
        wait
        echo "-----------------------------------"
        echo "| Extracting .oh-my-zsh.tar.xz... |"
        echo "-----------------------------------"
        tar -xf .oh-my-zsh.tar.xz
        wait
        echo "| Copying .oh-my-zsh.tar.xz... |"
        cp -r .oh-my-zsh ~/.oh-my-zsh
        #Used for testing purposes
        #cp -r .oh-my-zsh ~/test/.oh-my-zsh
        wait
        echo "-------------------------------"
        echo "| Cloning zsh autocomplete... |"
        echo "-------------------------------"
        echo
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/plugins
        #Used for testing purposes
        #git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/test/.oh-my-zsh/plugins/zsh-autocomplete
    else
        echo "---------------------------"
        echo "| Cloning config files... |"
        echo "---------------------------"
        echo
        git clone git@github.com:mem101296/zsh-config.git ~/git/zsh-config
        wait
        echo "--------------------------"
        echo "| Entering ZSH folder... |"
        cd ~/git/zsh-config
        echo "--------------------------"
        echo "| Copying p10k Config... |"
        echo "--------------------------"
        cp .p10k.zsh ~/.p10k.zsh
        #Used for testing purposes
        #cp .p10k.zsh ~/test/.p10k.zsh
        wait
        echo "| Copying .zshrc... |"
        cp .zshrc ~/.zshrc
        #Used for testing purposes
        #cp .zshrc ~/test/.zshrc
        wait
        echo "-----------------------------------"
        echo "| Extracting .oh-my-zsh.tar.xz... |"
        echo "-----------------------------------"
        tar -xf .oh-my-zsh.tar.xz
        wait
        echo "| Copying .oh-my-zsh.tar.xz... |"
        cp -r .oh-my-zsh ~/.oh-my-zsh
        #Used for testing purposes
        #cp -r .oh-my-zsh ~/test/.oh-my-zsh
        wait
        echo "-------------------------------"
        echo "| Cloning zsh autocomplete... |"
        echo "-------------------------------"
        echo
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/plugins
        #Used for testing purposes
        #git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/test/.oh-my-zsh/plugins/zsh-autocomplete
    fi
}
#############################################
#Closing the program
closing () {
    exit 1
}
#############################################



#############################################
#End of Functions
#############################################



#############################################
#Outputs author and purpose
echo "-----------------------------------------------------------------------------"
echo "| Made by Michael Martin                                                    |"
echo "| mike@pixelmail.io                                                         |"
echo "| Made to assist employees as Void Industries get a ZSH shell setup quickly |"
echo "-----------------------------------------------------------------------------"
read -p "Press enter to continue"
clear

#grab OS type for the next step
echo "-----------------------------------"
echo "| Please choose which OS you have |"
while true;do
    echo "-----------------------------------"
    echo "| Type \"Arch\" or \"Debian\":        |"
    echo "-----------------------------------"
    read -p "> " osType
    case $osType in
        "arch" | "Arch")
            break
            ;;
        "debian" | "Debian")
            break
            ;;
        *)
            echo "-----------------------------------"
            echo "| Invalid Input                   |" >&2
    esac
done

waterMarkOS=~"$osType"~

#############################################
#Asks if user would like packages installde
clear
while true; do
    echo $waterMarkOS
    echo "------------------------------------------------------------------------"
    echo "| Do you need zsh, oh-my-zsh, and powerlevel10k them installed? (Y/N): |"
    echo "------------------------------------------------------------------------"
    read -p "> " confirm
    case $confirm in
        [yY]*)
            break
            ;;
        [nN]*)
            break
            ;;
        *)
            echo "------------------------------------------------------------------------"
            echo "| Invalid Input                                                        |" >&2
    esac
done
#############################################
#Should be considered the "main" function. Calls other functions
clear
echo
if [[ $confirm == "n" || $confirm == "N" ]]; then
    echo $waterMarkOS
    echo "-----------------------------------------------------------"
    echo "| Double checking that required programs are installed... |"
    echo "-----------------------------------------------------------"
    sleep 1
    clear
    os_check
    mikes_file_prompt
else
    echo $waterMarkOS
    echo "----------------------------------------"
    echo "| Checking for clean install locations |"
    echo "----------------------------------------"
    sleep 1
    clear
    os_check
    mikes_file_prompt
fi
#############################################