#!/usr/bin/awk -f

@include "readfile"

BEGIN {

  str = readfile("file.txt")
  print str

}
