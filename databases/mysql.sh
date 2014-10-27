#!/bin/bash
#need to be a bash
if [ ! "$BASH_VERSION" ] ; then
    exec /bin/bash "$0"
fi

set -e

# import files to mysql
rds_import(){
    mysql -u $RDS_USERNAME -p${RDS_PASSWORD} -h $RDS_HOSTNAME -D $RDS_DB_NAME -P $RDS_PORT < $1;

}
# import files to mysql
rds_raw_import(){
    mysql -u $RDS_USERNAME -p${RDS_PASSWORD} -h $RDS_HOSTNAME -P $RDS_PORT -e "$1";

}
# import files to mysql
rds_import2(){
    mysql -u $RDS_USERNAME -p${RDS_PASSWORD} -h $RDS_HOSTNAME -D ${RDS_DB_NAME}_tmp -P $RDS_PORT < $1;

}
# def restore function
rds_restore()
{
    echo "error on database migration" 1>&2 &&
    sed -i "1iDROP DATABASE ${RDS_DB_NAME}; CREATE DATABASE ${RDS_DB_NAME}; "> tmpdb.sql &&
    rds_import tmpdb.sql;
}

# def backup function
rds_backup()
{
    size='0' &&
    >tmpdb.sql &&
    mysqldump -u $RDS_USERNAME -p${RDS_PASSWORD} -h $RDS_HOSTNAME --single-transaction --no-create-db --disable-keys $RDS_DB_NAME -P $RDS_PORT >> tmpdb.sql | while [ "$size" != "$(wc -c tmpdb.sql)" ]; do size=$(wc -c tmpdb.sql); echo $size; sleep 5; done;
    rds_raw_import "CREATE DATABASE ${RDS_DB_NAME}_tmp;" &&
    rds_import2 tmpdb.sql;

}

# def final action for migration
rds_finish()
{
  rds_raw_import "DROP DATABASE ${RDS_DB_NAME}_tmp;" &&
  rm tmpdb.sql;
}
