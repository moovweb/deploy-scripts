#!/bin/bash

# to use this wrapper, your project must have a folder in its main directory 
# called deploy-scripts and inside that must be a file called predep.sh
# if you want a different structure, you can modify the parameter in the wrapper script
# you can also add more parameters if they are set in stone (this example 
# was kept necessarily vague)
echo moov deploy --pre-deploy="deploy-scripts/predep.sh" $@