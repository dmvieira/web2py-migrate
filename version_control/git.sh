#!/bin/bash
#need to be a bash
if [ ! "$BASH_VERSION" ] ; then
    exec /bin/bash "$0"
fi

set -e

trap 'echo "error with your version control, please verify tags"; exit 1;' ERR
# check if tag is ok
vc_check_tag(){
    git rev-parse $TAG >/dev/null 2>&1
}
# go to tag version
vc_go_to_tag()
{
    git checkout $TAG;
}

# get status from version control
vc_status()
{
    git status;
}

# come back to default branch
vc_back_to_branch()
{
    git reset --hard HEAD;
    git checkout $BRANCH;
    git pull origin $BRANCH;
}

# remove that tag if migrate sucessful
vc_remove_tag()
{
    git tag -D $TAG;
    git push origin :${TAG};
}

# remove that tag if migrate sucessful
vc_add_tag()
{
    git tag $TAG;
    git push --tags;
}
