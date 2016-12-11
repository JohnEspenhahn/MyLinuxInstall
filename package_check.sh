#! /bin/bash

SOURCE=$1
REPOSITORY=$2
EXTRA=$3

# Check architecture
ARCH=$(uname -p)
if [ "$ARCH" = "x86_64" ]; then
	ARCH+="|amd64"
fi

# Add repository
if [ "$SOURCE" = "ppa" ]; then
	echo -e "\033[1;32m Adding repository ppa:"$REPOSITORY "\033[0m"
	sudo add-apt-repository --yes ppa:$REPOSITORY
	sudo apt-get update

	loadRepoFromList
elif [ "$SOURCE" = "curl" ]
then
	echo -e "\033[1;32m Adding repository from url https://"$EXTRA "\033[0m"
	curl -sL https://"$EXTRA" | sudo -E bash -

	PACKAGE=$REPOSITORY
elif [ "$SOURCE" = "default" ]
then
	PACKAGE=$REPOSITORY
fi

# Chack that a package was specified
if [ "$PACKAGE" = "" ]; then
	echo "No package provided!"
	exit
fi

echo -e "\033[1;32m Installing" $PACKAGE "\033[0m"
sudo apt-get install $PACKAGE

# Source dependent cleanup
if [ "$SOURCE" = "ppa" ]; then
	echo "Removing repositroy ppa:"$REPOSITORY
	sudo add-apt-repository --yes --remove ppa:$REPOSITORY
fi

function loadRepoFromList {
	# Check for number of matches
	REPO_PATH="${REPOSITORY/\//_}"
	PATH_CNT=$(sudo ls /var/lib/apt/lists/*$REPO_PATH*Packages | grep -n -E "$ARCH" | cut -d : -f 1)
	if [ "$PATH_CNT" = "0" ]; then
		echo "No results found"
		exit
	fi

	# Load first
	MY_PATH=$(sudo ls /var/lib/apt/lists/*$REPO_PATH*Packages | grep -E "$ARCH" | head -n 1) 
	if [ "$PATH_CNT" != "1" ]; then
		echo "More than one match found, using first"
		echo "First" $MY_PATH
	fi


	# Load package name from the found file
	PACKAGE=$(sudo cat $MY_PATH | grep -E "Package: " | awk -F ': ' '{ print $2 }')
}
