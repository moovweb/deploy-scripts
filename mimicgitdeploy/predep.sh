#!/bin/bash

# the user is responsible for making sure they are on the right branch, their repo is clean, etc.
outmsg=""

# cd $MOOV_DEPLOY_PROJECT_DIR

if [ -z "`git status -uno | grep 'working directory clean'`" ] ; then
  outmsg="There are changes to commit. "
fi

if [ "`git status -u | grep 'Untracked files:'`" ] ; then
  outmsg="${outmsg}There are untracked files. "
fi

if [ -n outmsg ]; then
  echo $outmsg 1>&2
  echo "Would you like to continue anyways? [y/n]" 1>&2
  read -n 1 cont
  echo 1>&2
  if [ $cont != "y" ] && [ $cont != "Y" ] ; then # don't exit if they say yes
    echo "Please verify the changes that will be deployed using `git diff`. After making necessary changes, try again." 1>&2
    exit 1
  fi
fi

# put the hash into the deploy id, put the commit message into the notes
echo MOOV_DEPLOY_DEPLOY_ID=`git rev-parse HEAD`
echo MOOV_DEPLOY_NOTES=`git log -1 --pretty=format:%s`