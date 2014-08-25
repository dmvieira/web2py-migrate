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
# def restore function
rds_restore()
{
    sed -i "1iDROP DATABASE ${RDS_DB_NAME}; "> tmpdb.sql;
    doing='1';
    rds_import tmpdb.sql  | while [ "$doing" != '0' ]; do echo 'restoring...'; sleep 5; done;
    doing='0';
    echo "error on database migration" 1>&2;
}

# def backup function
rds_backup()
{
    size='0';
    >tmpdb.sql;
    mysqldump -u $RDS_USERNAME -p${RDS_PASSWORD} -h $RDS_HOSTNAME --single-transaction --disable-keys $RDS_DB_NAME -P $RDS_PORT >> tmpdb.sql | while [ "$size" != "$(wc -c tmpdb.sql)" ]; do size=$(wc -c tmpdb.sql); echo $size; sleep 5; done;

}

# def final action for migration
rds_finish()
{
    rm tmpdb.sql;
}

