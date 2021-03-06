#!/bin/bash
#need to be a bash
if [ ! "$BASH_VERSION" ] ; then
    exec /bin/bash "$0"
fi

set -e

# import files to postgres
rds_import(){
    psql "user=${RDS_USERNAME} password=${RDS_PASSWORD} host=${RDS_HOSTNAME} port=${RDS_PORT} dbname=${RDS_DB_NAME}" -f $1;

}

# def import query to postgres
rds_rawimport()
{
	psql "user=${RDS_USERNAME} password=${RDS_PASSWORD} host=${RDS_HOSTNAME} port=${RDS_PORT} dbname=${RDS_DB_NAME}" -c "$1";
}

# def import query to a tmp database on postgres
rds_rawimport2()
{
    psql "user=${RDS_USERNAME} password=${RDS_PASSWORD} host=${RDS_HOSTNAME} port=${RDS_PORT} dbname=${RDS_DB_NAME}_tmp2" -c "$1";
}
# def restore function
rds_restore()
{
    echo "error on database migration, but your database might be ok" 1>&2 &&
    rds_rawimport2 "DROP DATABASE ${RDS_DB_NAME};" &&
    rds_rawimport2 "ALTER DATABASE ${RDS_DB_NAME}_tmp RENAME TO ${RDS_DB_NAME};" &&
    rds_rawimport "DROP DATABASE ${RDS_DB_NAME}_tmp2;";
}

# def backup function
rds_backup()
{
	rds_rawimport "CREATE DATABASE ${RDS_DB_NAME}_tmp WITH TEMPLATE ${RDS_DB_NAME} OWNER ${RDS_USERNAME};" &&
	rds_rawimport "CREATE DATABASE ${RDS_DB_NAME}_tmp2 WITH OWNER ${RDS_USERNAME};";
}

# def final action for migration
rds_finish()
{
	rds_rawimport "DROP DATABASE ${RDS_DB_NAME}_tmp;" &&
	rds_rawimport "DROP DATABASE ${RDS_DB_NAME}_tmp2;";
}
