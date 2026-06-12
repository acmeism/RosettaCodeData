dist=: +/&.:*:@:-"1/~10 10#:i.100

satsp=:4 :0
  kT=. 1
  pathcost=. [: +/ 2 {&y@<\ 0 , ] , 0:
  neighbors=. 0 (0}"1) y e. 1 2{/:~~.,y
  s=. (?~#y)-.0
  d=. pathcost s
  step=. x%10
  for_k. i.x+1 do.
    T=. kT*1-k%x
    u=. ({~ ?@#)s
    v=. ({~ ?@#)I.u{neighbors
    sk=. (<s i.u,v) C. s
    dk=. pathcost sk
    dE=. dk-d
    if. (^-dE%T) >?0 do.
      s=.sk
      d=.dk
    end.
    if. 0=step|k do.
      echo k,T,d
    end.
  end.
  0,s,0
)
