spindizzy=:3 :0
  'seq table'=. y
  ndx=.$0
  orig=. table
  for_sym. seq do.
    ndx=.ndx,table i.sym
    table=. sym,table-.sym
  end.
  ndx
  assert. seq-:yzzidnips ndx;orig
)

yzzidnips=:3 :0
  'ndx table'=. y
  seq=.''
  for_n. ndx do.
    seq=.seq,sym=. n{table
    table=. sym,table-.sym
  end.
  seq
)
