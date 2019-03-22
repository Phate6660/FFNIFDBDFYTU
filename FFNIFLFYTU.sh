#!/bin/bash

# Pull most recent version of firefox from Mozilla
echo "downloading Firefox Nightly"
wget -O ~/.FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=linux64&lang=en-US"
read -p "Nightly Downloaded"

# Extract the tar to /opt
echo "extracting tar"
sudo tar xjf ~/.FirefoxSetup.tar.bz2 -C /opt/
read -p  "Nightly Exctracted"

# Ask for custom directory if wanted. If not wanted, link to "$HOME/bin".
echo "Do you want to symlink to a custom directory, or just symlink to \"$HOME/bin\"?"
echo -e "=========================================================================\n"
options=(
    "Custom Directory"
    "$HOME/bin"
)
select option in "${options[@]}"; do
    case $option in
        ${options[0]})
            echo "Please input the full path of where you'd like to symlink. (Don't include the final slash)."
            read -r directory
            sudo ln -s /opt/firefox-nightly/firefox "$directory"/firefox
            break
        ;;
        ${options[1]})
            if test -d "$HOME"/bin; then
	    	ln -s /opt/firefox-nightly/firefox "$HOME"/bin/firefox-nightly
	    else 
	    	sudo mkdir -pv ~/bin
	    	ln -s /opt/firefox-nightly/firefox "$HOME"/bin/firefox-nightly
	    fi
	    break
        ;;
        *) 
            echo "Invalid option."
        ;;
    esac
done

# Remove the downloaded tar.
echo "Removing tar"
rm "$HOME"/.FirefoxSetup.tar.bz2
read -p "tar removed"
exit 0
