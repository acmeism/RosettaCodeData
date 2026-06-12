import std/[complex, math, parseutils, sequtils, strscans, strutils, terminal]

type
  # Sequence of floats with first index at -1.
  Vector = object
    data: seq[float]
  # Matrix of floats.
  Matrix = object
    data: seq[seq[float]]

func newVector(n: Natural): Vector =
  ## Create a vector with indices from -1 to "n".
  Vector(data: newSeq[float](n + 2))

func newMatrix(m, n: Natural): Matrix =
  ## Create a matrix with indices from 0 to "m" and 0 to "n".
  Matrix(data: newSeqWith(m + 1, newSeq[float](n + 1)))

func `[]`(v: Vector; i: int): float =
  ## Return the value at index "i".
  v.data[i + 1]

func `[]=`(v: var Vector; i: int; value: float) =
  ## Set the value at index "i".
  v.data[i + 1] = value

func `[]`(m: Matrix; i: int): seq[float] =
  ## Return the row at index "i".
  m.data[i]

func `[]`(m: var Matrix; i: int): var seq[float] =
  ## Return the row at index "i" as a variable.
  m.data[i]

proc input(prompt: string): string =
  ## Emit a prompt message and read a string.
  stdout.write prompt
  stdout.flushFile()
  if not stdin.readLine(result):
    quit "End of file encountered. Quitting.", QuitFailure
  result = result.strip()

const Echo = true

# The complexity of the algorithm increases with alpha,
# as does the quality guarantee on the lattice basis vectors:
# alpha = aln / ald, 1/4 < alpha < 1

const
  Aln = 80
  Ald = 81

# Rows and columns.
var m1, mn, nx, m, n: int
# Column indices.
var c1, c2: int

# Gram-Schmidt coefficients:
# mu_rs = lambda_rs / d_s
# Br = d_r / d_r-1
var la: Matrix
var d: Vector
# Work matrix.
var a: Matrix


proc inpConst(pr: int) =
  ## Input complex constant, read powers into A.
  let m2 = m1 + 1
  var x, y: float
  var op: char

  var g = input(" a + bi: ").strip()

  if not g.scanf("$f$s$c$s$fi", x, op, y) or op notin "+-":
    if scanf(g, "$f$.", x):
      y = 0.0
      op = '+'
    else:
      raise newException(ValueError, "wrong complex number")
  if op == '-': y = -y
  echo complex(x, y)

  # Fudge factor 1.
  a[0][m1] = 1
  # c^0.
  var p = 10.0^pr
  a[1][m1] = p
  var q = 0.0

  # Compute powers.
  for r in 2..<m:
    let t = p
    p = p * x - q * y
    q = t * y + q * x
    a[r][m1] = p.round
    a[r][m2] = q.round


proc inpSys(): bool =
  ## Input A and b.
  var sw = false

  for r in 0..<n:
    let g = input(" row A$1 and b$1 ".format(r + 1)).strip()
    # Reject all fractional coefficients.
    sw = sw or g.find({'.', '/'}) >= 0

    # Parse row.
    var s = 0
    for token in g.split({' ', '|'}):
      if token.len > 0:
        if s > m: echo "Ignoring extra characters."
        a[s][m1 + r] = token.parseFloat()
        inc s

  if sw: echo "illegal input"
  result = sw


template prow() =
  ## Print row r.
  for s in 0..mn:
    if s == m1: stdout.write " |"
    stdout.write spaces(p[s] - l[r][s] + 1)
    stdout.write a[r][s].toInt


proc printM(sw: bool) =
  ## Print matrix A.
  var l = newSeqWith(m + 1, newSeq[int](mn + 1))
  var p = newSeq[int](mn + 1)
  for s in 0..mn:
    p[s] = 1
    for r in 0..m:
      # Store lengths and max. length in column for pretty output.
      l[r][s] = len($a[r][s].toInt)
      p[s] = max(p[s], l[r][s])

  if sw:
    echo "P | Hnf"

    # Evaluate.
    var k: int
    for r in 0..m:
      if a[r][mn] != 0:
        k = r
        break
    var sw = a[k][mn] == 1
    for s in m1..<mn:
      sw = sw and a[k][s] == 0
    var g = if sw: "  -solution" else: "   inconsistent"
    for s in 0..<m:
      sw = sw and a[k][s] == 0
    if sw: g = ""   # Trivial.

    # Hnf and solution.
    for r in countdown(m, k):
      prow()
      echo if r == k: g else: ""
    # Null space with lengths squared.
    for r in 0..<k:
      prow()
      var q = 0.0
      for s in 0..<m:
        q += a[r][s]^2
      echo "   (", q.toInt, ")"

  else:
    echo "I | Ab~"
    for r in 0..m:
      prow()
      echo()


# HMM algorithm 4.

proc minus(t: int) =
  ## Negate rows t.
  for s in 0..mn:
    a[t][s] = -a[t][s]
  for r in 1..m:
    for s in 0..<r:
      if r == t or s == t:
        la[r][s] = -la[r][s]


proc reduce(k, t: int) =
  ## LLL reduce rows k.
  c1 = nx
  c2 = nx
  # Pivot elements Ab~ in rows t and k.
  for s in m1..mn:
    if a[t][s] != 0:
      c1 = s
      break
  for s in m1..mn:
    if a[k][s] != 0:
      c2 = s
      break

  var q = 0.0
  if c1 < nx:
    if a[t][c1] < 0: minus(t)
    q = floor(a[k][c1] / a[t][c1])
  else:
    let lk = la[k][t]
    if 2 * abs(lk) > d[t]:
      # 2|lambda_kt| > d_t
      # not LLL-reduced yet
      q = round(lk / d[t])

  if q != 0:
    let sx = if c1 == nx: m else: mn
    # Reduce row k.
    for s in 0..sx:
      a[k][s] -= q * a[t][s]
    la[k][t] -= q * d[t]
    for s in 0..<t:
      la[k][s] -= q * la[t][s]


proc swop(k: int) =
  ## Exchange rows k and k-1.
  let t = k - 1
  for s in 0..mn:
    swap a[k][s], a[t][s]
  for s in 0..<t:
    swap la[k][s], la[t][s]

  # Update Gram coefficients columns k, k-1 for r > k.
  let lk = la[k][t]
  let db = (d[t - 1] * d[k] + lk * lk) / d[t]
  for r in (k + 1)..m:
    let lr = la[r][k]
    la[r][k] = (d[k] * la[r][t] - lk * lr) / d[t]
    la[r][t] = (db * lr + lk * la[r][k]) / d[k]
  d[t] = db


proc main(sw: int) =
  ## Main limiting sequence.
  if sw != 0: inpConst(sw)
  elif inpSys(): return

  # Augment Ab~ with column e_m.
  a[m][mn] = 1

  # Prefix standard basis.
  for i in 0..m: a[i][i] = 1
  # Gram sub-determinants.
  for i in -1..m: d[i] = 1

  if Echo: printM(false)

  var k = 1
  var tl = 0
  while k <= m:
    let t = k - 1
    # Partial size reduction.
    reduce(k, t)

    var sw = (c1 == nx and c2 == nx)
    if sw:
      # Zero rows k-1, k.
      let lk = la[k][t]
      # Lovasz condition.
      # Bk >= (alpha - mu_kt^2) * Bt.
      let db = d[t - 1] * d[k] + lk * lk
      # Not satisfied.
      sw = db * Ald < d[t] * d[t] * Aln

    if sw or c1 <= c2 and c1 < nx:
      # Test recommends a swap.
      swop(k)
      if k > 1: dec k
    else:
      # Complete size reduction.
      for i in countdown(t - 1, 0):
        reduce(k, i)
      inc k
    inc tl

  printM(true)
  echo "loop ", tl


# Driver, input and output

var g: string

while true:
  echo()
  var sw = 0
  while true:
    g = input(" rows ")
    if not g.startsWith('\''): break
    echo g
    sw = sw or ord("const" in g)
  n = try: g.parseInt()
      except ValueError: break
  if n < 1: break

  g = input(" cols ")
  m = try: g.parseInt()
      except ValueError: break
  if m < 1:
    for i in 1..n: g = input("")
    continue

  # Set indices and allocate.
  if sw != 0:
    sw = n - 1
    n = 2
    inc m, 2
  m1 = m + 1
  mn = m1 + n
  nx = mn + 1
  la = newMatrix(m, m)
  d = newVector(m)
  a = newMatrix(m, mn)

  stdout.eraseScreen()
  main(sw)
  echo()
