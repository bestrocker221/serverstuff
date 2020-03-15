#!/bin/bash

if [ $# -ne 1 ]; then
	echo "usage:  $0 <n chars>"
	echo "try again.."
	exit 1
fi
# NOTE
# only lowercase, uppercase and numbers
tr -dc A-Za-z0-9 < /dev/urandom | head -c $1 ; echo