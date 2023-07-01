#!/bin/ksh

# List everything in the current folder (sorted), similar to `ls`

#	# Variables:
#
targetDir=${1:-/tmp/foo}

 ######
# main #
 ######

cd ${targetDir}
for obj in *; do
	print ${obj}
done
