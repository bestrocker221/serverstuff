#!/bin/sh

# $1 = WEBSITE
# Download the entire website into the current directory.

if [ $# -ne "1" ]; then
	echo "<commit text>"
	exit 1
fi

wget -k -p -nH -N $1
