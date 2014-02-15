#!/bin/bash

cd $MOOV_DEPLOY_PROJECT_DIR

if [ -z `which git` ]; then
  echo "... Seriously? You don't have git? Run brew install git, please." 1>&2
fi
for var do
  if [ $var = -t ]; then
    MOOV_DEPLOY_POST_DEPLOY_FLAGS="$MOOV_DEPLOY_POST_DEPLOY_FLAGS -t"
  	MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- Build should be tagged."
  else
    if [ $var != -h ]; then
      echo "Unknown flag: $var" 1>&2
      echo "" 1>&2
    fi
    echo "Supported flags are:" 1>&2
    echo "  -h   Display this help message." 1>&2
    echo "  -t   Push a tag of the build number on deploy attempts. Only works for clean directories." 1>&2
    exit 1
  fi
done

# make sure the dir is clean, exit out if it's not
if [ -z `git status | grep 'nothing to commit'` ]; then
    echo "Directory isn't fully clean. Commit/stash everything before deploying again." 1>&2
    exit 1
  fi
fi

echo MOOV_DEPLOY_DEPLOY_ID=`git rev-parse HEAD`
echo MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- git hash: `git rev-parse HEAD`"