wsum0=:4 :0
  p=:(#~ 0&<)y
  n=:(#~ 0&>)y
  poss=: +/@#~2#.inv 2 i.@^#
  P=:poss p
  N=:poss -n
  choose=:(1{I.P e. N){P
  keep=: [ #~ #&2@#@[ #: choose i.~ ]
  ;:inv words #~y e. (p keep P),n keep N
)
