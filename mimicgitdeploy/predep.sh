#!/bin/bash

# the user is responsible for making sure they are on the right branch, their repo is clean, etc.
outmsg=""

cd $MOOV_DEPLOY_PROJECT_DIR

if [ -z "`git status -uno | grep 'working directory clean'`" ] ; then
  outmsg="There are changes to commit. "
fi

if [ "`git status -u | grep 'Untracked files:'`" ] ; then
  outmsg="${outmsg}There are untracked files. "
fi

if [ "outmsg" ] ; then
  echo $outmsg 1>&2
  echo "Please ensure your repo is clean before attempting to deploy." 1>&2
  exit 1
fi

# put the hash into the deploy id, put the commit message into the notes
echo MOOV_DEPLOY_DEPLOY_ID=`git rev-parse HEAD`
echo MOOV_DEPLOY_NOTES=`git log -1 --pretty=format:%s`