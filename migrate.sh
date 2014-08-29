#!/bin/bash

#need to be a bash
if [ ! "$BASH_VERSION" ] ; then
    exec /bin/bash "$0"
fi

set -e

#local variables
MIGRATE="$(pwd)/migrate.py";
APP_PATH="${WEB2PY}/applications/${APP}";
DATABASES="${APP_PATH}/databases";
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

#get functions from db
. ${DIR}/databases/${DB_TYPE}.sh
#get functions from version control
. ${DIR}/version_control/${VERSION_CONTROL_TYPE}.sh

trap 'rds_restore || exit 10;'  INT TERM ERR

#execute web2py migrate script
make_migrate(){
    python ${WEB2PY}/web2py.py -S $APP -M -R $MIGRATE --no-banner;

}

#create web2py paths
mkdir $DATABASES $APP_PATH/sessions $APP_PATH/errors || true;

#default do not re send to version control
sendit=0;
echo "making database backup";
rds_backup || exit 10;
echo "executing pre-migrate sqls";
if [ -s "sql/before-${BRANCH}.sql" ];
then
    rds_import sql/before-${BRANCH}.sql && sendit=1 || exit 1;
fi
echo "making .tables with old db.py and fake_migrate if tag exists";
#if tag dont exists then just make first migrate
if vc_check_tag;
then
    echo "tag found!! making fake_migrate";
    export MIGRATE_ENV=1;
    export FAKE_MIGRATE_ENV=1;
    #go to tag to make fake tables
    vc_go_to_tag;
    make_migrate;
fi
echo "executing web2py migrate with deploy db.py";
export FAKE_MIGRATE_ENV=0;
#return current web2py folder, branch and commit
cd ${WEB2PY};
#just printing status for information
vc_status;
vc_back_to_branch;
#verify if you back to branch
vc_status;
#make migrate
cd ${DIR};
make_migrate;
echo "executing pos-migrate sqls";
if [ -s "sql/after-${BRANCH}.sql" ];
then
    rds_import sql/after-${BRANCH}.sql && sendit=1 || exit 1;
fi
export MIGRATE_ENV=0;
#last modifications with databases
rds_finish || echo "error cleaning test server, please use finish by hand";
echo "redefining tag"
vc_remove_tag || "error removing tag";
vc_add_tag || echo "error adding tag";
#send to version control again if did before and after migrates
if [ $sendit -eq 1 ];
then
    > sql/before-${BRANCH}.sql || echo "error cleaning before migrate";
    > sql/after-${BRANCH}.sql || echo "error cleaning after migrate";
    vc_send || echo "error sending again to vc without after and before migrates";
fi

echo "migrate ok!";
