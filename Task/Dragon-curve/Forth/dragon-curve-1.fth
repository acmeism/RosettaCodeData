include turtle.fs

2 value dragon-step

: dragon ( depth dir -- )
  over 0= if dragon-step fd  2drop exit then
  dup rt
  over 1-  45 recurse
  dup 2* lt
  over 1- -45 recurse
  rt drop ;

home clear
10 45 dragon
