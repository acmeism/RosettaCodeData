$$ MODE TUSCRIPT,{}
words=REQUEST("http://www.puzzlers.org/pub/wordlists/unixdict.txt")
size=SIZE(words)
ieei=cie=xie=cei=xei=0

LOOP word=words
IF (word.nc." ie "," ei ") CYCLE

IF (word.ct." ie "&& word.ct." ei ") THEN
 ieei=ieei+1
  IF (word.ct." Cie ") THEN
   cie=cie+1
  ELSEIF (word.ct." Cei ") THEN
   cei=cei+1
  ELSE
   xei=xei+1
  ENDIF
ENDIF

IF (word.ct." ie ") THEN
  IF (word.ct." Cie ") THEN
    cie=cie+1
  ELSE
    xie=xie+1
  ENDIF
ELSEIF (word.ct." ei ") THEN
  IF (word.ct." Cei ") THEN
    cei=cei+1
  ELSE
    xei=xei+1
  ENDIF
ENDIF

ENDLOOP

PRINT "ieee ", ieei
PRINT "cie  ", cie
PRINT "xie  ", xie
PRINT "cei  ", cei
PRINT "xei  ", xei

doublexei=2*xei
doublecei=cei*2

IF (xie>doublexei) THEN
 check1="plausible"
ELSE
 check1="not plausible"
ENDIF

IF (cei>xei) THEN
 check2="plausible"
ELSE
 check2="not plausible"
ENDIF
IF (check1==check2) THEN
 checkall="plausible"
ELSE
 checkall="not plausible"
ENDIF

TRAcE *check1,check2,checkall
