#!/bin/bash

if [ $# -ne 1 ]; then
	echo "usage:  $0 <URL>"
	echo "try again.."
	exit 1
fi

URL=$1
N=1000

echo "Fetching sitemap at: $URL/1_it_0_sitemap.xml"
wget --quiet https://$URL/1_it_0_sitemap.xml --no-cache --output-document - | egrep -o "http(s?):\/\/$URL[^] \"\(\)\<\>]*" | while read line; do
    time curl -A 'Cache Warmer' -s -L $line > /dev/null 2>&1
    echo $line
done
