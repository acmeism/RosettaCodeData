import math, strformat, strutils
import arraymancer

####################################################################################################
# First part: QR decomposition.

proc eye(n: Positive): Tensor[float] =
  ## Return the (n, n) identity matrix.
  result = newTensor[float](n.int, n.int)
  for i in 0..<n: result[i, i] = 1

proc norm(v: Tensor[float]): float =
  ## return the norm of a vector.
  assert v.shape.len == 1
  result = sqrt(dot(v, v)) * sgn(v[0]).toFloat

proc houseHolder(a: Tensor[float]): Tensor[float] =
  ## return the house holder of vector "a".
  var v = a / (a[0] + norm(a))
  v[0] = 1
  result = eye(a.shape[0]) - (2 / dot(v, v)) * (v.unsqueeze(1) * v.unsqueeze(0))

proc qrDecomposition(a: Tensor): tuple[q, r: Tensor] =
  ## Return the QR decomposition of matrix "a".
  assert a.shape.len == 2
  let m = a.shape[0]
  let n = a.shape[1]
  result.q = eye(m)
  result.r = a.clone
  for i in 0..<(n - ord(m == n)):
    var h = eye(m)
    h[i..^1, i..^1] = houseHolder(result.r[i..^1, i].squeeze(1))
    result.q = result.q * h
    result.r = h * result.r

####################################################################################################
# Second part: polynomial regression example.

proc lsqr(a, b: Tensor[float]): Tensor[float] =
  let (q, r) = a.qrDecomposition()
  let n = r.shape[1]
  result = solve(r[0..<n, _], (q.transpose() * b)[0..<n])

proc polyfit(x, y: Tensor[float]; n: int): Tensor[float] =
  var z = newTensor[float](x.shape[0], n + 1)
  var t = x.reshape(x.shape[0], 1)
  for i in 0..n: z[_, i] = t^.i.toFloat
  result = lsqr(z, y.transpose())

#———————————————————————————————————————————————————————————————————————————————————————————————————

proc printMatrix(a: Tensor) =
  var str: string
  for i in 0..<a.shape[0]:
    let start = str.len
    for j in 0..<a.shape[1]:
      str.addSep(" ", start)
      str.add &"{a[i, j]:8.3f}"
    str.add '\n'
  stdout.write str

proc printVector(a: Tensor) =
  var str: string
  for i in 0..<a.shape[0]:
    str.addSep(" ")
    str.add &"{a[i]:4.1f}"
  echo str


let mat = [[12, -51,   4],
           [ 6, 167, -68],
           [-4,  24, -41]].toTensor.astype(float)

let (q, r) = mat.qrDecomposition()
echo "Q:"
printMatrix q
echo "R:"
printMatrix r
echo()

let x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].toTensor.astype(float)
let y = [1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321].toTensor.astype(float)
echo "polyfit:"
printVector polyfit(x, y, 2)
