$$ MODE TUSCRIPT
remotedata = REQUEST ("http://www.rosettacode.org/mw/index.php?title=Special:Categories&limit=5000")
allmembers=allnames=""
COMPILE
LOOP d=remotedata
IF (d.sw."<li>") THEN
 name=EXTRACT (d,":<<a<><%>>:"|,":<</a>>:")
 IF (name.eq."Language users") CYCLE
 IF (name.sw."Unimplemented tasks") CYCLE
 IF (name.sw."Programming") CYCLE
 IF (name.sw."Solutions") CYCLE
 IF (name.sw."Garbage") CYCLE
 IF (name.sw."Typing") CYCLE
 IF (name.sw."BASIC LANG") CYCLE
 IF (name.ew."USER") CYCLE
 IF (name.ew."tasks") CYCLE
 IF (name.ew."attention") CYCLE
 IF (name.ew."related") CYCLE
 IF (name.ct."*omit*") CYCLE
 IF (name.ct.":*Categor*:") CYCLE
 IF (name.ct.":WikiSTUBS:") CYCLE
 IF (name.ct.":Impl needed:") CYCLE
 IF (name.ct.":Implementations:") CYCLE
 IF (name.ct.":':") name = EXCHANGE (name,":'::")
 members = STRINGS (d,":><1<>>/><<> member:")
 IF (members!="") THEN
  allmembers=APPEND (allmembers,members)
  allnames  =APPEND (allnames,name)
 ENDIF
ENDIF
ENDLOOP
index      = DIGIT_INDEX (allmembers)
index      = REVERSE (index)
allmembers = INDEX_SORT  (allmembers,index)
allnames   = INDEX_SORT  (allnames,  index)
ERROR/STOP CREATE ("list",SEQ-E,-std-)
time=time(),balt=nalt=""
FILE "list" = time
LOOP n, a=allnames,b=allmembers
 IF (b==balt) THEN
   nr=nalt
 ELSE
   nalt=nr=n
 ENDIF
 content=concat (nr,". ",a," --- ",b)
 FILE "list" = CONTENT
 balt=b
ENDLOOP
ENDCOMPILE
