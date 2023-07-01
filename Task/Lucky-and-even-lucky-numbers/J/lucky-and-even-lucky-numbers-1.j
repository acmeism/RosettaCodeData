luckySeq=:3 :0
  1 luckySeq y
:
  len=.0
  nth=.0
  seq=.x+2*i.4*y
  while.  len~:#seq do.
    len=. #seq
    nth=. nth+1
    seq=. nth exclude seq
  end.
)

exclude=: ] #~ 1 - #@] $ -@{ {. 1:

lucky=:''
evenLucky=:0
program=:3 :0
  range=: |y-.0
  seq=. (1+0 e.y) luckySeq >./range
  if. 0><./y do.
    (#~ e.&(thru/range)) seq
  else.
    (<:thru/range) { seq
  end.
)

thru=: <./ + i.@(+*)@-~
