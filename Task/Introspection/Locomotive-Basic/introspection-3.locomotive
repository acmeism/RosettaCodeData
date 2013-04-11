1 ' decide randomly whether to define the variable:
10 IF RND>.5 THEN bloop=-100*RND
20 ON ERROR GOTO 100
30 a=@bloop  ' try to get a pointer
40 PRINT "Variable bloop exists and its value is",bloop
50 PRINT "ABS of bloop is",ABS(bloop)
90 END
100 IF ERL=30 THEN PRINT "Variable bloop not defined":RESUME 90
