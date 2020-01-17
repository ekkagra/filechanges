#!/usr/bin/env bash

today=`date +"%Y%m%d"`

if [[ $# -ne 3 ]]; then
		echo "fileChanges.sh [tree logs directory] [target directory] [file system label]"
		exit 1
fi

function fileChange ()
{
	# ----- Parameters ----
	# 1 tree logs directory
	# 2 target directory
	# 3 file system label

	# remove "/" from end of tree logs directory. "/" will be added later
	if [[ ${1:(-1)} == "/" ]]; then
		treeLogs="${1:0:(-1)}"
	else
		treeLogs="$1"
	fi
	target="$2"
	fsLabel="$3"
	# echo "|$target| |$treeLogs| |$fsLabel|"
	cd "$target"
	if [[ $? -ne 0 ]]; then
		exit 1
	fi
	tree . > "$treeLogs"/tree_"$fsLabel"_"$today".txt
	cd "$treeLogs"
	# Find the last changed & 2nd last changed treeLog files for given file system. 
	treeNew=`ls -lt ./tree_"$fsLabel"_* | awk '{if(NR == 1) print $9}'`
	treeOld=`ls -lt ./tree_"$fsLabel"_* | awk '{if(NR == 2) print $9}'`
	if [[ $treeOld == '' ]]; then
		#statements
		echo "Old file not found for (target \"$target\", fsLabel \"$fsLabel\")"
		exit 1
	fi
	diff -u $treeOld $treeNew > ./"changes$fsLabel".txt
	cat ./"changes$fsLabel".txt
}

fileChange "$1" "$2" "$3"
# /usr/bin/gedit ./"changes$fsLabel.txt" &
# notify-send -t 10000 "changes$fsLabel.txt"
# read -rsp $'Press enter to continue...\n'