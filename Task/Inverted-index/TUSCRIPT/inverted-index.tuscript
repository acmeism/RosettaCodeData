$$ MODE TUSCRIPT

files="file1'file2'file3"
LOOP file=files
ERROR/STOP CREATE (file,seq-o,-std-)
ENDLOOP

content1="it is what it is"
content2="what is it"
content3="it is a banana"

FILE/ERASE "file1" = content1
FILE/ERASE "file2" = content2
FILE/ERASE "file3" = content3

ASK "search for": search=""
IF (search=="") STOP

BUILD R_TABLE/USER/AND search = *
DATA  {search}

LOOP/CLEAR file=files
 ACCESS q: READ/RECORDS $file s.z/u,content,count
  LOOP
  COUNT/NEXT/EXIT q (-; search;-;-)
  IF (count!=0) files=APPEND (files," ",file)
  ENDLOOP
 ENDACCESs q
ENDLOOP
PRINT "-> ",files
