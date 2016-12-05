import sequtils, permutationsswap

type Matrix[M,N: static[int]] = array[M, array[N, float]]

proc det[M,N](a: Matrix[M,N]): float =
  let n = toSeq 0..a.high
  for sigma, sign in n.permutations:
    var x = sign.float
    for i in n: x *= a[i][sigma[i]]
    result += x

proc perm[M,N](a: Matrix[M,N]): float =
  let n = toSeq 0..a.high
  for sigma, sign in n.permutations:
    var x = 1.0
    for i in n: x *= a[i][sigma[i]]
    result += x

const
  a = [ [1.0, 2.0]
      , [3.0, 4.0]
      ]
  b = [ [ 1.0,  2,  3,  4]
      , [ 4.0,  5,  6,  7]
      , [ 7.0,  8,  9, 10]
      , [10.0, 11, 12, 13]
      ]
  c = [ [ 0.0,  1,  2,  3,  4]
      , [ 5.0,  6,  7,  8,  9]
      , [10.0, 11, 12, 13, 14]
      , [15.0, 16, 17, 18, 19]
      , [20.0, 21, 22, 23, 24]
      ]

echo "perm: ", a.perm, " det: ", a.det
echo "perm: ", b.perm, " det: ", b.det
echo "perm: ", c.perm, " det: ", c.det
