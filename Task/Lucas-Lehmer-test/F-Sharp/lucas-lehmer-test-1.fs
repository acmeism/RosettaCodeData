let rec s mp n =
  if n = 1 then 4I % mp else ((s mp (n - 1)) ** 2 - 2I) % mp

[ for p in 2..47 do
    if p = 2 || s ((1I <<< p) - 1I) (p - 1) = 0I then
      yield p ]
