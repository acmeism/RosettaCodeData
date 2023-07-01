blocks$    = "BO,XK,DQ,CP,NA,GT,RE,TG,QD,FS,JW,HU,VI,AN,OB,ER,FS,LY,PC,ZM"
makeWord$  = "A,BARK,BOOK,TREAT,COMMON,SQUAD,Confuse"
b          = int((len(blocks$) /3) +  1)
dim blk$(b)

for i = 1 to len(makeWord$)
  wrd$ = word$(makeWord$,i,",")
  dim hit(b)
  n = 0
  if wrd$ = "" then exit for
  for k = 1 to len(wrd$)
    w$ = upper$(mid$(wrd$,k,1))
    for j = 1 to b
     if hit(j) = 0 then
      if w$ = left$(word$(blocks$,j,","),1) or w$ = right$(word$(blocks$,j,","),1) then
        hit(j) = 1
        n = n + 1
        exit for
      end if
     end if
    next j
  next k
  print wrd$;chr$(9);
  if n = len(wrd$) then print " True" else print " False"
next i
