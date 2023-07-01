#!/usr/bin/awk -f

BEGIN {
  print "There are " ARGC "command line parameters"
  for(l=1; l<ARGC; l++) {
    print "Argument " l " is " ARGV[l]
  }
}
