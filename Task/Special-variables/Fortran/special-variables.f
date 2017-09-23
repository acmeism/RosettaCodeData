           INQUIRE(FILE = FILENAME(1:L),EXIST = EXIST,	!Here we go. Does the file exist?
     1      ERR = 666,IOSTAT = IOSTAT) 		!Hopefully, named in good style, etc.
           IF (EXIST) THEN	!So, does the named file already exist?
           ...etc.
