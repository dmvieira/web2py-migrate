#!/bin/bash
#need to be a bash
if [ ! "$BASH_VERSION" ] ; then
    exec /bin/bash "$0"
fi

set -e

# import files to dummy
rds_import(){
	echo "importing...";
}
# def restore function
rds_restore()
{
    echo "restoring...";
}

# def backup function
rds_backup()
{
	echo "backuping...";
}

# def final action for migration
rds_finish()
{
    echo "finishing..."
}

