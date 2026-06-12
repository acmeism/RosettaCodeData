#!/bin/sh
# 0 :0
  echo unix shell commands go here
  echo presumably this will condition the environment
  echo for example:
  cd working-directory
  echo or maybe you want to modify $PATH, ... whatever...
  echo then start up J:
  exec jconsole "$0" "$@"
)

NB. exit on error
onfail_z_=:3 :0
  1!:2&2 ARGV
  1!:2&2]13!:12'' NB. display error message
  2!:55>:13!:11'' NB. exit with 1 origin error number
)
9!:27 'onfail 1'
9!:29]1

NB. and then the rest of the file is J
echo 'hi!'
echo 'your command line arguments were:'
echo ARGV
echo p:i. 3 4
exit 0
