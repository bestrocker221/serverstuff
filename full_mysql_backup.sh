#!/bin/bash

#
#	Make full backup of local mysql database
#

USER=
PASSWORD=

mysqldump -u ${USER} --password=${PASSWORD} -A -R -E --triggers --single-transaction > full_backup_`date | sed -e 's/ //g'`.mysql