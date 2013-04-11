$$ MODE TUSCRIPT
file="lines.txt"
ERROR/STOP OPEN (file,READ,-std-)
line2fetch=7

--> solution 1
ACCESS file: READ/RECORDS/UTF8 $file s,line
LOOP n=1,99
READ/NEXT/EXIT file
IF (n==line2fetch) PRINT line
ENDLOOP
ENDACCESS file

--> solution 2
line1to7=FILE (file,#line2fetch)
line=SELECT (line1to7,#line2fetch)
PRINT line
