$$ MODE TUSCRIPT
files="a.txt'b.txt'c.txt"

BUILD S_TABLE search = ":Goodbye London!:"

LOOP file=files
 ERROR/STOP OPEN (file,WRITE,-std-)
 ERROR/STOP CREATE ("scratch",FDF-o,-std-)
  ACCESS q: READ/STREAM/RECORDS/UTF8 $file s,aken+text/search+eken
  ACCESS s: WRITE/ERASE/STREAM/UTF8 "scratch" s,aken+text+eken
   LOOP
    READ/EXIT q
    IF (text.ct.search) SET text="Hello New York!"
    WRITE/ADJUST s
   ENDLOOP
  ENDACCESS/PRINT q
  ENDACCESS/PRINT s
 ERROR/STOP COPY ("scratch",file)
 ERROR/STOP CLOSE (file)
ENDLOOP
ERROR/STOP DELETE ("scratch")
