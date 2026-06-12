#!/usr/bin/awk -E
# -E instead of -f so program arguments don't conflict with Gawk arguments
@include "getopt.awk"
BEGIN {
  while ((C = getopt(ARGC, ARGV, "ht:u:")) != -1) {
    opti++
    if(C == "h") {
      usage()
      exit
    }
    if(C == "t")
      tval = Optarg
    if(C == "u")
      uval = Optarg
  }
  print "There are " opti " arguments."
  if(tval) print "-t = " tval
  if(uval) print "-u = " uval
}
