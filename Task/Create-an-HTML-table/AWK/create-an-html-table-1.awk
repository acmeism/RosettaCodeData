#!/usr/bin/awk -f
BEGIN {
   print "<table>\n  <thead align = \"right\">"
   printf "    <tr><th></th><td>X</td><td>Y</td><td>Z</td></tr>\n  </thead>\n  <tbody align = \"right\">\n"
   for (i=1; i<=10; i++) {
       printf "    <tr><td>%2i</td><td>%5i</td><td>%5i</td><td>%5i</td></tr>\n",i, 10*i, 100*i, 1000*i-1
   }
   print "  </tbody>\n</table>\n"
}
