$$ MODE TUSCRIPT
joblog="mlijobs.txt",jobnrout=0
log=FILE (joblog)
DICT jobnrout CREATE
LOOP l=log
jobout=EXTRACT (l,":License :"|,": :")
 IF (jobout=="out") THEN
  time=EXTRACT (l,":@ :"|,": :"), jobnrout=jobnrout+1
  DICT jobnrout APPEND/QUIET jobnrout,num,cnt,time;" "
 ELSE
  jobnrout=jobnrout-1
 ENDIF
ENDLOOP
DICT jobnrout UNLOAD jobnrout,num,cnt,time
DICT jobnrout SIZE maxlicout
times=SELECT (time,#maxlicout)
PRINT "The max. number of licences out is ", maxlicout
PRINT "at these times: ", times
