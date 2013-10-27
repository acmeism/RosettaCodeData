#!/usr/bin/awk -f
BEGIN {
  b=0;
  print "<"b,length(b)">"
  print "<"u,length(u)">"
  print "<"u+0,length(u+0)">";
}
