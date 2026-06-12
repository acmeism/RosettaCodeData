import math, sequtils, strutils

const
  N = 32
  NMax = 40_000

type Save = tuple[p: ptr int; v: int]

var
  u: array[N, int]  # Upper bounds.
  l: array[N, int]  # Lower bounds.
u[0] = 1; u[1] = 2
l[0] = 1; l[1] = 2

var outp, sum, tail: array[N, int]

var cache: array[NMax + 1, int]
cache[2] = 1

var
  known = 2
  stack = 0
  undo: array[N * N, Save]


proc replace(x: var openArray[int]; i, n: int) =
  undo[stack] = (x[i].addr, x[i])
  x[i] = n
  inc stack


proc restore(n: int) =
  while stack > n:
    dec stack
    undo[stack].p[] = undo[stack].v


proc bounds(n: int): tuple[lower, upper: int] =
  # Return lower and upper bounds.
  if n <= 2 or n <= NMax and cache[n] != 0:
    return (cache[n], cache[n])
  var
    i = -1
    o = 0
    n = n
  while n != 0:
    if (n and 1) != 0: inc o
    n = n shr 1
    inc i
  dec i
  result.upper = o + i
  while true:
    inc i
    o = o shr 1
    if o == 0: break
  o = 2
  while o * o < n:
    if n mod o == 0:
      let q = cache[o] + cache[n div o]
      if q < result.upper:
        result.upper = q
        if q == i: break
    inc o
  if n > 2:
    if result.upper > cache[n - 2] + 1:
      result.upper = cache[n - 1] + 1
    if result.upper > cache[n - 2] + 1:
      result.upper = cache[n - 2] + 1
  result.lower = i


proc insert(x, pos: int): bool =
  let save = stack

  if l[pos] > x or u[pos] < x:
    return false

  if l[pos] != x:
    l.replace(pos, x)
    var i = pos - 1
    while u[i] * 2 < u[i+1]:
      let t = l[i+1] + 1
      if t * 2 > u[i]:
        restore(save)
        return false
      l.replace(i, t)
      dec i
    i = pos + 1
    while l[i] <= l[i-1]:
      let t = l[i-1] + 1
      if t > u[i]:
        restore(save)
        return false
      l.replace(i, t)
      inc i

  if u[pos] == x:
    return true

  u.replace(pos, x)
  var i = pos - 1
  while u[i] >= u[i+1]:
    let t = u[i+1] - 1
    if t < l[i]:
      restore(save)
      return false
    u.replace(i, t)
    dec i
  i = pos + 1
  while u[i] > u[i-1] * 2:
    let t = u[i-1] * 2
    if t < l[i]:
      restore(save)
      return false
    u.replace(i, t)
    inc i

  result = true


# Forward reference.
proc seqRecur(le: int): bool


proc `try`(p, q, le: int): bool =

  var pl = cache[p]
  if pl >= le: return false
  var ql = cache[q]
  if ql >= le: return false

  while pl < le and u[pl] < p: inc pl
  var pu = pl - 1
  while pu < le - 1 and u[pu+1] >= p: inc pu

  while ql < le and u[ql] < q: inc ql
  var qu = ql - 1
  while qu < le - 1 and u[qu+1] >= q: inc qu

  if p != q and pl <= ql: pl = ql + 1
  if pl > pu or ql > qu or ql > pu: return false

  if outp[le] == 0:
    pu = le - 1
    pl = pu

  let ps = stack
  while pu >= pl:
    if insert(p, pu):
      inc outp[pu]
      inc sum[pu], le
      if p != q:
        let qs= stack
        var j = qu
        if j >= pu: j = pu - 1
        while j >= ql:
          if insert(q, j):
            inc outp[j]
            inc sum[j], le
            tail[le] = q
            if seqRecur(le - 1): return true
            restore(qs)
            dec outp[j]
            dec sum[j], le
          dec j
      else:
        inc outp[pu]
        inc sum[pu], le
        tail[le] = p
        if seqRecur(le - 1): return true
        dec outp[pu]
        dec sum[pu], le
      dec outp[pu]
      dec sum[pu], le
      restore(ps)
    dec pu


proc seqRecur(le: int): bool =
  let n = l[le]
  if le < 2: return true
  var limit = n - 1
  if outp[le] == 1: limit = n - tail[sum[le]]
  if limit > u[le-1]: limit = u[le-1]
  # Try to break n into p + q, and see if we can insert p, q into
  # list while satisfying bounds.
  var p = limit
  var q = n - p
  while q <= p:
    if `try`(p, q, le): return true
    dec p
    inc q


# Forward reference.
proc sequence(n, le: int): int


proc seqLen(n: int): int =

  if n <= known: return cache[n]

  # Need all lower n to compute sequence.
  while known + 1 < n:
    discard seqLen(known + 1)

  var (lb, ub) = bounds(n)
  while lb < ub and sequence(n, lb) == 0: inc lb

  known = n
  if (n and 1023) == 0: echo "Cached: ", known
  cache[n] = lb
  result = lb


proc sequence(n, le: int): int =
  let le = if le != 0: le else: seqLen(n)
  stack = 0
  l[le] = n
  u[le] = n
  for i in 0..le:
    outp[i] = 0
    sum[i] = 0
  for i in 2..<le:
    l[i] = l[i-1] + 1
    u[i] = u[i-1] * 2
  for i in countdown(le - 1, 3):
    if l[i] * 2 < l[i+1]:
      l[i] = (1 + l[i+1]) div 2
    if u[i] >= u[i+1]:
      u[i] = u[i+1] - 1

  if not seqRecur(le): return 0
  result = le


proc sequence(n, le: int; buf: var openArray[int]): int =
  let le = sequence(n, le)
  for i in 0..le: buf[i] = u[i]
  result = le


proc binLen(n: int): int =
  var r, o = -1
  var n = n
  while n != 0:
    if (n and 1) != 0: inc o
    n = n shr 1
    inc r
  result = r + o


type
  Vector = seq[float]
  Matrix = seq[Vector]


func `*`(m1, m2: Matrix): Matrix =
  let
    rows1 = m1.len
    cols1 = m1[0].len
    rows2 = m2.len
    cols2 = m2[0].len
  if cols1 != rows2:
    raise newException(ValueError, "Matrices cannot be multiplied.")

  result = newSeqWith(rows1, newSeq[float](cols2))
  for i in 0..<rows1:
    for j in 0..<cols2:
      for k in 0..<rows2:
        result[i][j] += m1[i][k] * m2[k][j]


proc pow(m: Matrix; n: int; printout: bool): Matrix =
  var e = newSeq[int](N)
  var v: array[N, Matrix]
  let le = sequence(n, 0, e)
  if printout:
    echo "Addition chain:"
    echo e[0..le].join(" ")
  v[0] = m
  v[1] = m * m
  for i in 2..le:
    block loop2:
      for j in countdown(i - 1, 0):
        for k in countdown(j, 0):
          if e[k] + e[j] < e[i]: break
          if e[k] + e[j] > e[i]: continue
          v[i] = v[j] * v[k]
          break loop2
  result = v[le]


func `$`(m: Matrix): string =
  for v in m:
    result.add '['
    let start = result.len
    for x in v:
      result.addSep(" ", start)
      result.add x.formatFloat(ffDecimal, precision = 6).align(9)
    result.add "]\n"


var m = 27182
var n = 31415
echo "Precompute chain lengths:"
discard seqlen(n)
let rh = sqrt(0.5)
let mx: Matrix = @[@[ rh, 0.0,  rh, 0.0, 0.0, 0.0],
                   @[0.0,  rh, 0.0,  rh, 0.0, 0.0],
                   @[0.0,  rh, 0.0, -rh, 0.0, 0.0],
                   @[-rh, 0.0,  rh, 0.0, 0.0, 0.0],
                   @[0.0, 0.0, 0.0, 0.0, 0.0, 1.0],
                   @[0.0, 0.0, 0.0, 0.0, 1.0, 0.0]]

echo "\nThe first 100 terms of A003313 are:"
for i in 1..100:
  stdout.write seqLen(i), ' '
  if i mod 10 == 0: echo()

let exs = [m, n]
var mxs: array[2, Matrix]
for i, ex in exs:
  echo()
  echo "Exponent: ", ex
  mxs[i] = mx.pow(ex, true)
  echo "A ^ $#:\n".format(ex)
  echo mxs[i]
  echo "Number of A/C multiplies: ", seqLen(ex)
  echo "  c.f. Binary multiplies: ", binLen(ex)
echo()
echo "Exponent: $1 x $2 = $3".format(m, n, m * n)
echo "A ^ $1 = (A ^ $2) ^ $3:\n".format(m * n, m, n)
echo mxs[0].pow(n, false)
