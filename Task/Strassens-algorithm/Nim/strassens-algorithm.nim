import math, sequtils, strutils

type Matrix = seq[seq[float]]

template rows(m: Matrix): Positive = m.len
template cols(m: Matrix): Positive = m[0].len


func `+`(m1, m2: Matrix): Matrix =
  doAssert m1.rows == m2.rows and m1.cols == m2.cols, "Matrices must have the same dimensions."
  result = newSeqWith(m1.rows, newSeq[float](m1.cols))
  for i in 0..<m1.rows:
    for j in 0..<m1.cols:
      result[i][j] = m1[i][j] + m2[i][j]


func `-`(m1, m2: Matrix): Matrix =
  doAssert m1.rows == m2.rows and m1.cols == m2.cols, "Matrices must have the same dimensions."
  result = newSeqWith(m1.rows, newSeq[float](m1.cols))
  for i in 0..<m1.rows:
    for j in 0..<m1.cols:
      result[i][j] = m1[i][j] - m2[i][j]


func `*`(m1, m2: Matrix): Matrix =
  doAssert m1.cols == m2.rows, "Cannot multiply these matrices."
  result = newSeqWith(m1.rows, newSeq[float](m2.cols))
  for i in 0..<m1.rows:
    for j in 0..<m2.cols:
      for k in 0..<m2.rows:
        result[i][j] += m1[i][k] * m2[k][j]


func toString(m: Matrix; p: Natural): string =
  ## Round all elements to 'p' places.
  var res: seq[string]
  let pow = 10.0^p
  for row in m:
    var line: seq[string]
    for val in row:
      let r = round(val * pow) / pow
      var s = r.formatFloat(precision = -1)
      if s == "-0": s = "0"
      line.add s
    res.add '[' & line.join(" ") & ']'
  result = '[' & res.join(" ") & ']'


func params(r, c: int): array[4, array[6, int]] =
  [[0, r, 0, c, 0, 0],
   [0, r, c, 2 * c, 0, c],
   [r, 2 * r, 0, c, r, 0],
   [r, 2 * r, c, 2 * c, r, c]]


func toQuarters(m: Matrix): array[4, Matrix] =
  let
    r = m.rows() div 2
    c = m.cols() div 2
    p = params(r, c)
  for k in 0..3:
    var q = newSeqWith(r, newSeq[float](c))
    for i in p[k][0]..<p[k][1]:
      for j in p[k][2]..<p[k][3]:
        q[i-p[k][4]][j-p[k][5]] = m[i][j]
    result[k] = move(q)


func fromQuarters(q: array[4, Matrix]): Matrix =
  var
    r = q[0].rows
    c = q[0].cols
  let p = params(r, c)
  r *= 2
  c *= 2
  result = newSeqWith(r, newSeq[float](c))
  for k in 0..3:
    for i in p[k][0]..<p[k][1]:
      for j in p[k][2]..<p[k][3]:
        result[i][j] = q[k][i-p[k][4]][j-p[k][5]]


func strassen(a, b: Matrix): Matrix =
  doAssert a.rows == a.cols() and b.rows == b.cols and a.rows == b.rows,
           "Matrices must be square and of equal size."
  doAssert a.rows != 0 and (a.rows and (a.rows-1)) == 0,
           "Size of matrices must be a power of two."
  if a.rows == 1: return a * b

  let
    qa = a.toQuarters()
    qb = b.toQuarters()
    p1 = strassen(qa[1] - qa[3], qb[2] + qb[3])
    p2 = strassen(qa[0] + qa[3], qb[0] + qb[3])
    p3 = strassen(qa[0] - qa[2], qb[0] + qb[1])
    p4 = strassen(qa[0] + qa[1], qb[3])
    p5 = strassen(qa[0], qb[1] - qb[3])
    p6 = strassen(qa[3], qb[2] - qb[0])
    p7 = strassen(qa[2] + qa[3], qb[0])

  var q: array[4, Matrix]
  q[0] = p1 + p2 - p4 + p6
  q[1] = p4 + p5
  q[2] = p6 + p7
  q[3] = p2 - p3 + p5 - p7
  result = fromQuarters(q)


when isMainModule:
  let
    a = @[@[float 1, 2],
          @[float 3, 4]]
    b = @[@[float 5, 6],
          @[float 7, 8]]
    c = @[@[float 1, 1, 1, 1],
          @[float 2, 4, 8, 16],
          @[float 3, 9, 27, 81],
          @[float 4, 16, 64, 256]]
    d = @[@[4.0, -3, 4/3, -1/4],
          @[-13/3, 19/4, -7/3, 11/24],
          @[3/2, -2, 7/6, -1/4],
          @[-1/6, 1/4, -1/6, 1/24]]
    e = @[@[float 1, 2, 3, 4],
          @[float 5, 6, 7, 8],
          @[float 9, 10, 11, 12],
          @[float 13, 14, 15, 16]]
    f = @[@[float 1, 0, 0, 0],
          @[float 0, 1, 0, 0],
          @[float 0, 0, 1, 0],
          @[float 0, 0, 0, 1]]

  echo "Using 'normal' matrix multiplication:"
  echo "  a * b = ", (a * b).toString(10)
  echo "  c * d = ", (c * d).toString(6)
  echo "  e * f = ", (e * f).toString(10)

  echo "\nUsing 'Strassen' matrix multiplication:"
  echo "  a * b = ", strassen(a, b).toString(10)
  echo "  c * d = ", strassen(c, d).toString(6)
  echo "  e * f = ", strassen(e, f).toString(10)
