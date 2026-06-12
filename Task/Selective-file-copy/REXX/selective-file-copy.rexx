in='in.txt'
out='out.txt'; 'erase' out
Do While lines(in)>0
  l=linein(in)
  Parse Var l a +5 b +5 c +4 d +5
  chex=c2x(c)
  cpic=left(chex,2)
  call lineout out,a||cpic||'XXXXX'
  End
Call lineout in
Call lineout out
'type' out
