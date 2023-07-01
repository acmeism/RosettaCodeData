swap=: C.~ <

siftDown=: 4 : 0
  'c e'=. x
  while. e > c=.1+2*s=.c do.
    before=. <&({&y)
    if. e > 1+c do. c=.c+ c before c+1 end.
    if. s before c do. y=. y swap c,s else. break. end.
  end.
  y
)

heapSort=: 3 : 0
  if. 1>: c=. # y do. y return. end.
  z=. siftDown&.>/ (c,~each i.<.c%2),<y        NB. heapify
  > ([ siftDown swap~)&.>/ (0,each}.i.c),z
)
