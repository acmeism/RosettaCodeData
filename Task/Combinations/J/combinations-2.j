comb=: dyad define M.
  if. (x>:y)+.0=x do. i.(x<:y),x else. (0,.x comb&.<: y),1+x comb y-1 end.
)
