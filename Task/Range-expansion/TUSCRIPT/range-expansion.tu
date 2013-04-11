$$ MODE TUSCRIPT
rangednrs="-6,-3--1,3-5,7-11,14,15,17-20"
expandnrs=SPLIT (rangednrs,":,:")

LOOP/CLEAR r=expandnrs
 test=STRINGS (r,":><-><<>>/:")
 sz_test=SIZE (test)
 IF (sz_test==1) THEN
  expandnrs=APPEND (expandnrs,r)
 ELSE
  r=SPLIT (r,"::<|->/::-:",beg,end)
  expandnrs=APPEND (expandnrs,beg)
  LOOP/CLEAR next=beg,end
   next=next+1
   expandnrs=APPEND (expandnrs,next)
   IF (next==end) EXIT
  ENDLOOP
 ENDIF
ENDLOOP
expandnrs= JOIN (expandnrs,",")

PRINT expandnrs
