$$! input=testfile,begnr=3,endnr=4
$$ MODE TUSCRIPT
- CREATE inputfile
ERROR/STOP CREATE (input,FDF-o,-std-)
FILE/ERASE $input
 LOOP n=1,9
 content=CONCAT ("line",n)
 DATA {content}
 ENDLOOP
ENDFILE

- CREATE outputfile
output="outputfile"

ERROR/STOP CREATE (output,fdf-o,-std-)
ACCESS q:  READ/RECORDS/utf8 $input  L,line
ACCESS z: WRITE/RECORDS/utf8 $output L,line
PRINT "content: of output-file"
LOOP/9999
READ/NEXT/EXIT q
IF (begnr<=L&&endnr>=L) CYCLE
PRINT line
WRITE z
ENDLOOP
ENDACCESS/PRINT q
ENDACCESS/PRINT z
