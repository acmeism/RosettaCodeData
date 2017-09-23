# combination(r) generates a stream of combinations of r items from the input array.
def combination(r):
  if r > length or r < 0 then empty
  elif r == length then .
  else  ( [.[0]] + (.[1:]|combination(r-1))),
        ( .[1:]|combination(r))
  end;
