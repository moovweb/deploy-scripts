deploy-scripts
==============

Sample moov deploy pre-deploy and post-deploy scripts.

basicexample
============

This is a very basic example to show everything you can manipulate with pre-deploy scripts and how to do it.

fleshedout
==========

This is a complex example that shows just how powerful the deploy scripts can become. This particular example allows you to use coffeescript, automatically tag the deploys, minifies js, and checks for a clean directory, allowing overriding of the default behavior. It also makes sure every program required for the features invoked are installed and prompts the user to install them if they don't. This is still a fairly basic example. It can be used as a model for other complex scripts people want to build.

mimicgitdeploy
==============

This is a script that mimics the pre-5.0 git deploy functionality. It will make sure the directory is clean and doesn't have untracked files present. If either is true, it will exit out with a message telling the user what went wrong. If it doesn't error out, it will put the githash of the HEAD into the deploy ID field and the latest commit log into the notes field, just like the old git push functionality.  It also contains a wrapper for moov deploy (called deploy) that makes the amount you need to type a bit less. It can be modified to have more parameters wrapped if necessary.

silly
=====

This is a script to show how you can do literally whatever you want with the deploy scripts, including REST calls. It also provides a concrete example of not using a shell script as a deploy script.

strippeddown
============

This script is a subset of features in the fleshedout folder. It only includes automatic tagging, which necessitates the removal of the force flag.