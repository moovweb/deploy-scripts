#!/bin/bash

# the user is responsible for making sure they are on the right branch, their repo is clean, etc.

cd $MOOV_DEPLOY_PROJECT_DIR

# put the hash into the deploy id, put the commit message into the notes
echo MOOV_DEPLOY_DEPLOY_ID=`git rev-parse HEAD`
echo MOOV_DEPLOY_NOTES=`git log -1 --pretty=format:%s`