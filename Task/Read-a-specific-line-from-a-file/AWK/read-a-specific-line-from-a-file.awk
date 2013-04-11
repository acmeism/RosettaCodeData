#!/usr/bin/awk -f
#usage: readnthline.awk -v lineno=6 filename
FNR==lineno { storedline=$0; found++ }
END {if(found<1){print "ERROR: Line",lineno,"not found"}
