#!/bin/bash

cd $MOOV_DEPLOY_PROJECT_DIR

COMPILE="false"
MINFIY="false"
TAGIT="false"

# if you need to run this script manually (if you end the deploy command prematurely or it crashes or something):
#  - you can use the -c flag without worrying, it doesn't affect the .coffee files, so you don't need to worry at all
#  - you should be VERY careful about using the -m flag, it might overwrite your .js files to a previous state
#  - don't use the -t flag and instead manually make the tag yourself, it has a high chance of completely screwing up the repo

for var do
	if [ $var = "-t" ]; then
		TAGIT="true"
	elif [ $var = "-c" ]; then
		COMPILE="true"
	elif [ $var = "-m" ]; then
		MINFIY="true"
	else
		echo "Unknown flag: $var" 1>&2 # don't exit, we need to preform other cleanup things regardless...
	fi
done

if [ $COMPILE = "true" ]; then
	echo "Coffeescript files were compiled in the predeploy, removing generated files." 1>&2
	find . -name *\.coffee | while read x; do
		rm ${x%.coffee}.js
	done
	echo "Deleted all compiled coffeescript files." 1>&2
fi

# after removing any generated .js files
if [ $MINFIY = "true" ]; then
	echo "js files were minified before being sent to the cloud, reverting minification." 1>&2
	find . -name *\.js | while read x; do
		git checkout $x
	done
	echo "Rechecked out all js files." 1>&2
fi

# tag the current commit with the build number and push the tag
# do this after the other cleanup steps are performed
if [ $TAGIT = "true" ]; then
	echo "tagging the deployed code"  1>&2
	TAG="v$MOOV_DEPLOY_MODE_VERSION"
	git tag -a $TAG -m "automated deploy of build $MOOV_DEPLOY_MODE_VERSION"
	git push origin $TAG
fi
