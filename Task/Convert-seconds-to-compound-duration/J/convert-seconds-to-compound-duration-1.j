fmtsecs=: verb define
  seq=. 0 7 24 60 60 #: y
  }: ;:inv ,(0 ~: seq) # (8!:0 seq) ,. <;.2'wk,d,hr,min,sec,'
)
