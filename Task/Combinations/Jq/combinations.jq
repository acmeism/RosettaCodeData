def combination(r):
  if r > length or r < 0 then empty
  elif r == length then .
  else  ( [.[0]] + (.[1:]|combination(r-1))),
        ( .[1:]|combination(r))
  end;

# select r integers from the set (0 .. n-1)
def combinations(n;r): [range(0;n)] | combination(r);
