#!/bin/bash
#need to be a bash
if [ ! "$BASH_VERSION" ] ; then
    exec /bin/bash "$0"
fi

set -e

trap 'echo "error with your version control, please verify tags"; exit 1;' ERR
# check if tag is ok
vc_check_tag()
{
	echo "checking tag...";
}
# go to tag version
vc_go_to_tag()
{
    echo "going to tag...";
}

# get status from version control
vc_status()
{
	echo "getting status from version control...";
}

# come back to default branch
vc_back_to_branch()
{
    echo "backing to branch..."
}

# remove that tag if migrate sucessful
vc_remove_tag()
{
    echo "removing tag..."
}

# remove that tag if migrate sucessful
vc_add_tag()
{
    echo "adding tag..."
}