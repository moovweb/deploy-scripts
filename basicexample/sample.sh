#!/bin/bash

# example script, the purpose of which is to show all the variables and the absolute basics of how to mutate them
echo $MOOV_DEPLOY_ACCOUNT_NAME >&2
echo $MOOV_DEPLOY_SITE_NAME >&2
echo $MOOV_DEPLOY_MODE >&2
echo $MOOV_DEPLOY_PROJECT_DIR >&2
echo $MOOV_DEPLOY_LAYER >&2
echo $MOOV_DEPLOY_DEPLOYMENT_ID >&2
echo $MOOV_DEPLOY_PRE_DEPLOY >&2
echo $MOOV_DEPLOY_POST_DEPLOY >&2
echo $MOOV_DEPLOY_NOTES >&2
echo $MOOV_DEPLOY_MODE_VERSION >&2 # only available in the post-deploy
echo $MOOV_DEPLOY_STATUS >&2 # only available in the post-deploy

# what is going to happen...
echo "Overriding these:" >&2
echo "	site: demosite" >&2
echo "	mode: demomode" >&2
echo "	layer: demolayer" >&2
echo "	deployment id: some_git_hash" >&2
echo "	notes: these are the deployment notes" >&2

#and how to make those changes...
echo MOOV_DEPLOY_SITE_NAME="demosite"
echo MOOV_DEPLOY_MODE="demomode"
echo MOOV_DEPLOY_LAYER="demolayer"
echo MOOV_DEPLOY_DEPLOYMENT_ID="some_git_hash"
echo MOOV_DEPLOY_NOTES="these are the deployment notes"

