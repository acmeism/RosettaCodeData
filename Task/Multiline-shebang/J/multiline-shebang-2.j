#!/bin/sh
# 0 :0
  echo unix shell commands go here
  echo presumably this will condition the environment
  echo for example:
  cd working-directory
  echo or maybe you want to modify $PATH, ... whatever...
  echo then start up J:
  if jconsole -jprofile "$0" "$@"; then
    echo success
  else
    echo failure
  fi
  exit $?
)

9!:29]1[9!:27'2!:55]1' NB. exit on error
(3 :'0!:0 y')<BINPATH,'/profile.ijs'

NB. and then the rest of the file is J
echo 'hi!'
echo 'your command line arguments were:'
echo ARGV
echo p:i. 3 4
exit 0
