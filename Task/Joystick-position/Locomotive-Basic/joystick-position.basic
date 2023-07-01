10 MODE 1:BORDER 14:x=320:y=200:d=1
20 a=JOY(0)  ' read state of first joystick
30 IF d THEN q$="*" ELSE q$=" "
40 IF a THEN MOVE x-8,y+8:TAG:PRINT q$;:TAGOFF
50 IF (a AND 1) AND y<380 THEN y=y+10
60 IF (a AND 2) AND y>20  THEN y=y-10
70 IF (a AND 4) AND x>20  THEN x=x-10
80 IF (a AND 8) AND x<620 THEN x=x+10
90 IF a AND 16 THEN LOCATE 1,1:PRINT "Fire1 pressed":d=1
100 IF a AND 32 THEN LOCATE 1,2:PRINT "Fire2 pressed":d=0
110 IF a<16 THEN LOCATE 1,1:PRINT "             ":PRINT "             "
120 MOVE x-8,y+8:TAG:PRINT "X";:TAGOFF
130 GOTO 20
