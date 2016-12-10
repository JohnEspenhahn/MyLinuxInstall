#! /bin/bash

REPOSITORY=webupd8team/sublime-text-3

# Add repository
echo "Adding repository ppa:"$REPOSITORY
sudo add-apt-repository --yes ppa:$REPOSITORY
sudo apt-get update

# Check architecture
ARCH=$(uname -p)
if [ "$ARCH" = "x86_64" ]; then
	ARCH+="|amd64"
fi
echo "Architecture: " $ARCH

# Check for number of matches
REPO_PATH="${REPOSITORY/\//_}"
PATH_CNT=$(sudo ls /var/lib/apt/lists/*$REPO_PATH*Packages | grep -n -E "$ARCH" | cut -d : -f 1)
if [ "$PATH_CNT" = "0" ]; then
	echo "No results found"
	exit
fi
if [ "$PATH_CNT" != "1" ]; then
	echo "More than one match found, using first"
fi
# Load first
MY_PATH=$(sudo ls /var/lib/apt/lists/*$REPO_PATH*Packages | grep -E "$ARCH" | head -n 1)

# echo $PATH
PACKAGE=$(sudo cat $MY_PATH | grep -E "Package: " | awk -F ': ' '{ print $2 }')

echo "Installing" $PACKAGE
sudo apt-get install $PACKAGE

# Remove repository
echo "Removing repositroy ppa:"$REPOSITORY
sudo add-apt-repository --yes --remove ppa:$REPOSITORY
