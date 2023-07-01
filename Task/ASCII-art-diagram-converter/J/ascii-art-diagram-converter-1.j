require'strings'

soul=: -. {.
normalize=: [:soul' ',dltb;._2

mask=: 0: _1} '+' = {.
partition=: '|' = mask #"1 soul
labels=: ;@(([: <@}: <@dltb;._1)"1~ '|'&=)@soul
names=: ;:^:(0 = L.)

unpacker=:1 :0
  p=. , partition normalize m
  p #.;.1 (8#2) ,@:#: ]
)

packer=:1 :0
  w=. -#;.1 ,partition normalize m
  _8 (#.\ ;) w ({. #:)&.> ]
)

getter=:1 :0
  nm=. labels normalize m
  (nm i. names@[) { ]
)

setter=:1 :0
  q=. ''''
  n=. q,~q,;:inv labels normalize m
  1 :('(',n,' i.&names m)}')
)

starter=:1 :0
  0"0 labels normalize m
)
