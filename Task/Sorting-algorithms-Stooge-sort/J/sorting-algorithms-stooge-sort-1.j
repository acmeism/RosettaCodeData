swapElems=: |.@:{`[`]}

stoogeSort=: 3 : 0
  (0,<:#y) stoogeSort y
:
  if. >/x{y do. y=.x swapElems y end.
  if. 1<-~/x do.
    t=. <.3%~1+-~/x
    (x-0,t) stoogeSort (x+t,0) stoogeSort (x-0,t) stoogeSort y
  else. y end.
)
