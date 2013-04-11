#! /bin/bash
# Warning: globstar excludes hidden directories.
# Turn on recursive globbing (in this script) or exit if the option is not supported:
shopt -s globstar || exit

for f in **
do
  if [[ "$f" =~ \.txt$ ]] ; then
    echo "$f"
  fi
done
