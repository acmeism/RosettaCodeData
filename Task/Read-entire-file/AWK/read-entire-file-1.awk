#!/usr/bin/awk -f
BEGIN {
   ## empty record separate,
   RS="";
   ## read line (i.e. whole file) into $0	
   getline; 	
   ## print line number and content of line
   print "=== line "NR,":",$0;
}
{
   ## no further line is read printed
   print "=== line "NR,":",$0;
}
