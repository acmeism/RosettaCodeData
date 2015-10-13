ltp=:3 :0
  probe=. i.1 0
  while. #probe do.
    probe=. (#~ 1 p: y #.]),/(}.i.y),"0 _1/have=. probe
  end.
  >./y#.have
)
