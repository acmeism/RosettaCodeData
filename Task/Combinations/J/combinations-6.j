combr=: dyad define M.
  if. (x>:y)+.0=x do. i.(x<:y),x else. (0,.x combr&.<: y),1+x combr y-1 end.
)
