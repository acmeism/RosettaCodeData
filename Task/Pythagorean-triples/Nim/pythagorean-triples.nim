const u = [[ 1, -2,  2,  2, -1,  2,  2, -2,  3],
           [ 1,  2,  2,  2,  1,  2,  2,  2,  3],
           [-1,  2,  2, -2,  1,  2, -2,  2,  3]]

var
  total, prim = 0
  maxPeri = 10

proc newTri(ins: array[0..2, int]) =
  var p = ins[0] + ins[1] + ins[2]
  if p > maxPeri: return
  inc(prim)
  total += maxPeri div p

  for i in 0..2:
    newTri([u[i][0] * ins[0] + u[i][1] * ins[1] + u[i][2] * ins[2],
            u[i][3] * ins[0] + u[i][4] * ins[1] + u[i][5] * ins[2],
            u[i][6] * ins[0] + u[i][7] * ins[1] + u[i][8] * ins[2]])

while maxPeri <= 100_000_000:
  total = 0
  prim = 0
  newTri([3, 4, 5])
  echo "Up to ", maxPeri, ": ", total, " triples, ", prim, " primitives"
  maxPeri *= 10
