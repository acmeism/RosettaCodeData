import sequtils

type Matrix[T] = seq[seq[T]]

func kroneckerProduct[T](a, b: Matrix[T]): Matrix[T] =
  result = newSeqWith(a.len * b.len, newSeq[T](a[0].len * b[0].len))
  let m = a.len
  let n = a[0].len
  let p = b.len
  let q = b[0].len
  for i in 0..<m:
    for j in 0..<n:
      for k in 0..<p:
        for l in 0..<q:
          result[i * p + k][j * q + l] = a[i][j] * b[k][l]

func kroneckerPower(m: Matrix; n: int): Matrix =
  result = m
  for i in 2..n:
    result = kroneckerProduct(result, m)

func `$`(m: Matrix): string =
  for row in m:
    for val in row:
      result.add if val == 0: "  " else: " *"
    result.add '\n'


type B = range[0..1]

const A1: Matrix[B] = @[@[B 0, 1, 0], @[B 1, 1, 1], @[B 0, 1, 0]]
echo "Vicsek fractal:\n", A1.kroneckerPower(4)
echo ""
const A2: Matrix[B] = @[@[B 1, 1, 1], @[B 1, 0, 1], @[B 1, 1, 1]]
echo "Sierpinski carpet fractal:\n", A2.kroneckerPower(4)
