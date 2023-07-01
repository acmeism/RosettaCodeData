# usage: awk  -f readlines.awk  *.txt
BEGIN  { print "# Reading..." }
FNR==1 { f++; print "# File #" f, ":", FILENAME }
/^#/   { c++; next }               # skip lines starting with "#", but count them
/you/  { gsub("to", "TO") }        # change text in lines with "you" somewhere
/TO/   { print FNR,":",$0; next }  # print with line-number
       { print }                   # same as "print $0"
END    { print "# Done with", f, "file(s), with a total of", NR, "lines." }
END    { print "# Comment-lines:", c }
