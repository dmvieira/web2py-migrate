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
    git checkout $TAG &&
    git submodule update --recursive;
}

# get status from version control
vc_status()
{
    git status;
}

# come back to default branch
vc_back_to_branch()
{
    git reset --hard HEAD &&
    git checkout $BRANCH &&
    git pull origin $BRANCH &&
    git submodule update --recursive;
}

# remove that tag if migrate sucessful
vc_remove_tag()
{
    git tag -d $TAG &&
    git push origin :${TAG} || true;
}

# remove that tag if migrate sucessful
vc_add_tag()
{
    git tag $TAG &&
    git push --tags;
}

# sending new code to version control
vc_send()
{
    git config --global user.email "test@server.com"
    git config --global user.name "Test Server"
    git commit -am "new code without before and after migrates scripts" &&
    git push origin HEAD;
}
