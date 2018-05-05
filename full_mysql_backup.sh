#!/bin/bash

#
#	Make full backup of local mysql database
#

USER=
PASSWORD=

mysqldump -u ${USER} --password=${PASSWORD} -A -R -E --triggers --single-transaction > full_backup_`date | sed -e 's/ //g'`.mysql


# Copy one/more database
# mysqldump -u user -p db > backup.sql
# mysqldump -u user -p --databases db1 db2 db3> backup.sql
# mysqldump -u user -p --all-databases > backup.sql

#Only one table
#mysqldump -u user -p db table > backup.sql
#mysqldump -u user -p --where="id > 10" db table > backup.sql

# Compress db
#mysqldump -u user -p db_da_copiare | gzip -9 > backup.sql.gz


## How to Recover backup

#mysql -u user -p < backup.sql
#mysql -u user -p --one-database db < file_with_all_db.sql

#From gz archive
#gunzip < backup.sql.gz | mysql -u user -p
