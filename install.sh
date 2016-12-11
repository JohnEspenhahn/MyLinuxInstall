#! /bin/bash

REPOS[0]=ppa:webupd8team/sublime-text-3 # sublime
REPOS[1]=curl:nodejs:deb.nodesource.com/setup_7.x # npm
REPOS[2]=default:build-essential # build-essential for npm
REPOS[3]=default:git-all # git
REPOS[4]=npm:typescript # npm:typescript

for i in "${REPOS[@]}"
do
	SPLIT=(${i//:/ })
	bash package_check.sh "${SPLIT[0]}" "${SPLIT[1]}" "${SPLIT[2]}"
done

echo "Cleaning..."
apt-get autoclean

echo -e "\033[1;32mInstall complete!"
