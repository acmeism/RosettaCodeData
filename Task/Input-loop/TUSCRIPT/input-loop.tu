$$ MODE TUSCRIPT
file="a.txt"
ERROR/STOP OPEN (file,READ,-std-)
ACCESS source: READ/RECORDS/UTF8 $file s,text
LOOP
    READ/NEXT/EXIT source
    PRINT text
ENDLOOP
ENDACCESS source
