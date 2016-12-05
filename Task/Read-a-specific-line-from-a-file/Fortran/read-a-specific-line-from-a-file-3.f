      READ (F,REC = 7,ERR = 666, IOSTAT = IOSTAT) STUFF(1:80)
  666 IF (IOSTAT.NE.0) THEN
        WRITE (MSG,*) "Can't get the record: code",IOSTAT
       ELSE
        WRITE (MSG,1) "Record",STUFF(1:80)
      END IF
