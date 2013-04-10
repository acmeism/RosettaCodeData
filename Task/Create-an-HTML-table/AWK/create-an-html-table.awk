#!/usr/bin/awk -f
BEGIN {
   print "<table>\n  <thead align = \"right\">";
   printf "    <tr><th></th><td>X</td><td>Y</td><td>Z</td></tr>\n  </thead>\n  <tbody align = \"right\">\n";
};

{
    printf "    <tr><td>%2i</td><td>%5i</td><td>%5i</td><td>%5i</td></tr>\n",NR,$1,$2,$3;
};

END {
   print "  </tbody>\n</table>\n";
};
