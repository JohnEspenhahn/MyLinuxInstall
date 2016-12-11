#! /bin/bash

REPOS[0]=ppa:webupd8team/sublime-text-3
REPOS[1]=curl:nodejs:deb.nodesource.com/setup_7.x
REPOS[2]=default:build-essential

for i in "${REPOS[@]}"
do
	SPLIT=(${i//:/ })
	bash package_check.sh "${SPLIT[0]}" "${SPLIT[1]}" "${SPLIT[2]}"
done
