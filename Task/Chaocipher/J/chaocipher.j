reset =:  verb define
  LEFT  =:  'HXUCZVAMDSLKPEFJRIGTWOBNYQ'
  RIGHT =:  'PTLNBQDEOYSFAVZKGJRIHWXUMC'
)

enc =:  verb define
  z =.  LEFT  {~ i =. RIGHT i. y
  permute {. i
  z
)

dec =:  verb define
  z =.  RIGHT {~ i =. LEFT i. y
  permute {. i
  z
)

permute =: verb define
  LEFT  =:  LEFT  |.~ - y
  LEFT  =:  (1 |. 13 {. LEFT) , 13 }. LEFT

  RIGHT =:  RIGHT |.~ - y + 1
  RIGHT =:  ({. RIGHT) , (1 |. RIGHT {~ 2+i.12) , 13 }. RIGHT
)

chao =:  enc :. dec

reset ''
smoutput E =.  chao 'WELLDONEISBETTERTHANWELLSAID'
reset ''
smoutput D =.  chao^:_1 E
