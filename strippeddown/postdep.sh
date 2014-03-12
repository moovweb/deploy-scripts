#!/bin/bash

cd $MOOV_DEPLOY_PROJECT_DIR

TAGIT="false"

# you shouldn't run this script manually and instead just tag the branch normally if you have to

for var do
	if [ $var = "-t" ]; then
		TAGIT="true"
	else
		echo "Unknown flag: $var" 1>&2 # don't exit, we need to preform other cleanup things regardless...
	fi
done

# tag the current commit with the build number and push the tag
if [ $TAGIT = "true" ]; then
	echo "tagging the deployed code"
	TAG="v$MOOV_DEPLOY_MODE_VERSION"
	git tag -a $TAG -m "automated deploy of build $MOOV_DEPLOY_MODE_VERSION"
	git push origin $TAG
fi
