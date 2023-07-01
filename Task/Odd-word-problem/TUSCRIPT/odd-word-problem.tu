$$ MODE TUSCRIPT
inputstring=*
DATA what,is,the;meaning,of:life.
DATA we,are;not,in,kansas;any,more.

BUILD C_GROUP >[pu]=".,;:-"

LOOP i=inputstring
pu=STRINGS (i,"|>[pu]|")
wo=STRINGS (i,"|<></|")
outputstring=""
 loop n,w=wo,p=pu
 r=MOD(n,2)
 IF (r==0) w=TURN (w)
 outputstring=CONCAT(outputstring,w,p)
ENDLOOP
PRINT outputstring
ENDLOOP
