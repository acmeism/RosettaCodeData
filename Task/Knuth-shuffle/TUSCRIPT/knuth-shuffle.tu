$$ MODE TUSCRIPT
oldnumbers=newnumbers="",range=20
LOOP nr=1,#range
 oldnumbers=APPEND(oldnumbers,nr)
ENDLOOP

PRINT "before ",oldnumbers

LOOP r=#range,1,-1
 RANDNR=RANDOM_NUMBERS (1,#r,1)
 shuffle=SELECT (oldnumbers,#randnr,oldnumbers)
 newnumbers=APPEND(newnumbers,shuffle)
ENDLOOP

PRINT "after  ",newnumbers
