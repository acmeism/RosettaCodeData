left=0
rite=0
lo=hex(left)hex(rite)
Say 'low   ' c2x(lo)
left=random(0,2**16-1)
rite=random(0,2**16-1)
rand=hex(left)hex(rite)
Say 'random' c2x(rand)
left=2**16-1
rite=2**16-1
hi=hex(left)hex(rite)
Say 'high  ' c2x(hi)
Exit
hex: Return d2c(arg(1),2)
