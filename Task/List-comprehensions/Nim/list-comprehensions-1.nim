import sugar, math

let n = 20
let triplets = collect(newSeq):
  for x in 1..n:
    for y in x..n:
      for z in y..n:
        if x^2 + y^2 == z^2:
          (x,y,z)
echo triplets
