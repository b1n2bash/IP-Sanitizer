#!/bin/bash

# Author: Ben Pirkl
# Date: 2/21/2020
# Title: IP Log Sanitizer
# Purpose:
# The purpose of this script is to be able
# to create dummy data by replacing all IP's found
# a log file with a randomly generated one.
# IPs that appear multiple times in the file will have
# all their occurences replaced as well.

# User Provided Log File.
LOG=$1

# Check that the user only provided a filename
if [[ $# != 1 ]]
then
	echo "Please provide a file: $0 <filename>"
	exit
# Check if the provided filename is a valid file
elif [ ! -s $LOG  ]
then
	echo "The file you provided is invalid: $LOG"
	exit
fi

# Get all IPs found in the file, seperated by line.
DATA=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $LOG)
# Cut down duplicates, only show the unique IPs
UNIQ_LINES=$(echo "$DATA" | awk '!seen[$0]++')
# For each unique IP, replace it with a randomly generated one
for line in $(echo "$UNIQ_LINES")
do
	RANDIP=$(echo $((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256)))
	# Replace all of the Real IPs appearances with the newly generated one
	sed -i "s/$line/$RANDIP/g" $LOG
done
