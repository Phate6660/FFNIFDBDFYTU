#!/bin/bash

# Make sure user is not root.
if [ "$(id -u)" = 0 ]; then
	echo "Why are you running this as root?"
	exit 1
fi

# Pull most recent version of Firefox Nightly from Mozilla.
echo "downloading Firefox Nightly"
wget "https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=linux64&lang=en-US" -O ~/.FirefoxSetup.tar.bz2 
read -p "Nightly Downloaded. Press [ENTER] to continue."

# Extract the tar to "/opt".
clear
echo -e "Extracting tar to \"/opt\".\nIf you wish to inspect the files, they will be located in \"/opt/firefox\".\nPlease wait until you get the message stating that the tar is extracted."
sudo tar xjf ~/.FirefoxSetup.tar.bz2 -C /opt/
read -p  "Nightly Extracted. Press [ENTER] to continue."

# Ask for custom directory if wanted. If not wanted, link to "$HOME/bin".
clear
echo -e "Do you want to symlink to a custom directory, or just symlink to \"$HOME/bin\"?\nMake sure that whatever directory you choose is in your \$PATH.\n"
options=(
    "Custom Directory"
    "$HOME/bin"
)
select option in "${options[@]}"; do
    case $option in
        ${options[0]})
            echo "Please input the full path of where you'd like to symlink. (Don't include the final slash)."
            read -r directory
            sudo ln -s /opt/firefox/firefox "$directory"/firefox-nightly
			echo "Firefox executable has been symlinked to \"$directory/firefox-nightly\"."
            break
        ;;
        ${options[1]})
            [ ! -d "$HOME/bin" ] && echo "Creating \"$HOME/bin\", make sure to add it to your \$PATH." && mkdir -pv "$HOME/bin"
			ln -s /opt/firefox/firefox "$HOME"/bin/firefox-nightly
			echo "Firefox executable has been symlinked to \"$HOME/bin/firefox-nightly\"."
			break
        ;;
        *) echo "Invalid option.";;
    esac
done

# Remove the downloaded tar.
clear
echo "Removing tar."
rm "$HOME"/.FirefoxSetup.tar.bz2
clear
read "tar removed. Script is finished. You may use firefox-nightly now."
exit 0
