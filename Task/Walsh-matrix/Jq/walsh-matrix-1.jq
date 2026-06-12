## Generate a Walsh matrix of size 2^$n for $n >= 1
def walsh:
  . as $n
  | [[1, 1], [1, -1]] as $w2
  | if $n < 2 then $w2 else kprod($w2; $n - 1 | walsh) end;
