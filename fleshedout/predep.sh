#!/bin/bash

cd $MOOV_DEPLOY_PROJECT_DIR

FORCE="false"
FORCED="false"
MINIFY="false"
COMPILE="false"
TAGIT="false"
TAGGED="false"
MOOV_DEPLOY_POST_DEPLOY_FLAGS=""

# parse options + checks for required programs
if [ -z `which git` ]; then
  echo "... Seriously? You don't have git? Run brew install git, please." 1>&2
fi
for var do
  if [ $var = -f ]; then
    FORCE="true"
  elif [ $var = -m ]; then
    if [ -z `which yuicompressor` ]; then
      echo "yuicompressor not installed, please run `brew install yuicompressor` (and install the JDK if needed)." 1>&2
      exit 1
    fi
    MINIFY="true"
  elif [ $var = -c ]; then
    if [ -z `which coffee` ]; then
      echo "Follow the instructions at https://gist.github.com/Frobitz/3257794 to install coffeescript." 1>&2
      exit 1
    fi
    COMPILE="true"
    MOOV_DEPLOY_POST_DEPLOY_FLAGS="$MOOV_DEPLOY_POST_DEPLOY_FLAGS -c"
  elif [ $var = -t ]; then
    TAGIT="true"
    MOOV_DEPLOY_POST_DEPLOY_FLAGS="$MOOV_DEPLOY_POST_DEPLOY_FLAGS -t"
    MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- The deploy should have an automated tag generated."
  else
    if [ $var != -h ]; then
      echo "Unknown flag: $var" 1>&2
      echo "" 1>&2
    fi
    echo "Supported flags are:" 1>&2
    echo "  -c  Compiles all coffeescript files in the project can find." 1>&2
    echo "  -f  Forces the script to deploy even with unclean directory, says it was forced in the notes if it would've otherwise failed." 1>&2
    echo "  -h  Display this help message." 1>&2
    echo "  -m  Attempts to minify js files found. Will be ignored if the deploy is forced." 1>&2
    echo "  -t  Set a tag to try to push. If this is set, the force flag is ignored." 1>&2
    exit 1
  fi
done

# make sure the dir is clean, allow through if forced, but display a message
if [ -z "`git status | grep 'nothing to commit'`" ]; then # check to see if the repo is clean
  if [ $FORCE = "true" ] && [ $TAGIT != "false" ]; then
    echo "The deploy is being forced, ctrl+c to cancel if this is a mistake." 1>&2
    sleep 2 # give some chance to stop a possibly incorrect deploy
    echo "Continuing..." 1>&2
    MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- The directory was unclean and forced to deploy."
    FORCED="true"
  else
    echo "Directory isn't fully clean, either fix that or rerun the script with the -f option if it's all good to go." 1>&2
    echo "Note that forcing the deploy may, in fact, ruin your repo's state. Use the force flag with caution." 1>&2
    exit 1
  fi
else 
  MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- Push of a clean directory."
fi

if [ $COMPILE = "true" ] || [ $MINIFY = "true" ]; then
  echo "superuser priviliges are required..." 1>&2 # just so they don't freak out when they are prompted for password
fi

# handle the compile coffeescript flag
if [ $COMPILE = "true" ]; then
  find $MOOV_DEPLOY_PROJECT_DIR -name *\.coffee | while read x; do
    coffee -p -c $x | sudo yuicompressor --type js -o ${x%.coffee}.js 
  done
  MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- Build had .coffee files compiled."
fi

#handle the minify js flag
if [ $MINIFY = "true" ]; then
  if [ $FORCED != "true" ]; then # might be unable to revert minification if it was forced and not tagged, so don't try it
    find $MOOV_DEPLOY_PROJECT_DIR -name *\.js | while read x; do 
      sudo yuicompressor $x -o $x
    done
    MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- Build's js files were minified prior to deploy."
    MOOV_DEPLOY_POST_DEPLOY_FLAGS="$MOOV_DEPLOY_POST_DEPLOY_FLAGS -m"
  else
    MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- Skipped js minification because it might be irreversible."
  fi
fi

echo MOOV_DEPLOY_DEPLOY_ID=`git rev-parse HEAD`
echo MOOV_DEPLOY_NOTES="$MOOV_DEPLOY_NOTES -- git rev-parse HEAD => `git rev-parse HEAD`"
echo MOOV_DEPLOY_POST_DEPLOY="$MOOV_DEPLOY_POST_DEPLOY $MOOV_DEPLOY_POST_DEPLOY_FLAGS"