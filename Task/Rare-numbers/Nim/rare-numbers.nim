import algorithm, math, strformat, times

type Llst = seq[seq[int]]

const
  # Powers of 10.
  P = block:
        var p: array[19, int64]
        p[0] = 1i64
        for i in 1..18: p[i] = 10 * p[i - 1]
        p

  # Digital root lookup array.
  Drar = block:
           var drar: array[19, int]
           for i in 0..18: drar[i] = i shl 1 mod 9
           drar

var
  d: seq[int]           # permutation working slice
  dac: seq[int]         # running digital root slice
  ac: seq[int64]        # accumulator slice
  pp: seq[int64]        # coefficient slice that combines with digits of working slice
  sr: seq[int64]        # temporary list of squares used for building

var
  odd = false     # flag for odd number of digits
  sum: int64      # calculated sum of terms (square candidate)
  cn = 0          # solution counter
  nd = 2          # number of digits
  nd1 = nd - 1    # 'nd' helper
  ln: int         # previous value of 'n' (in recurse())
  dl: int         # length of 'd' slice

func newIntSeq(f, t, s: int): seq[int] =
  ## Return a sequence of integers.
  result = newSeq[int]((t - f) div s + 1)
  var f = f
  for i in 0..result.high:
    result[i] = f
    inc f, s

const
  Tlo = @[0, 1, 4, 5, 6]                   # primary differences starting point
  All = newIntSeq(-9, 9, 1)                # all possible differences
  Odl = newIntSeq(-9, 9, 2)                # odd possible differences
  Evl = newIntSeq(-8, 8, 2)                # even possible differences
  Thi = @[4, 5, 6, 9, 10, 11, 14, 15, 16]  # primary sums starting point
  Alh = newIntSeq(0, 18, 1)                # all possible sums
  Odh = newIntSeq(1, 17, 2)                # odd possible sums
  Evh = newIntSeq(0, 18, 2)                # even possible sums
  Ten = newIntSeq(0, 9, 1)                 # used for odd number of digits
  Z   = newIntSeq(0, 0, 1)                 # no difference, avoids generating a bunch of negative square candidates
  T7  = @[-3, 7]                           # shortcut for low 5
  Nin = @[9]                               # shortcut for hi 10
  Tn  = @[10]                              # shortcut for hi 0 (unused, unneeded)
  T12 = @[2, 12]                           # shortcut for hi 5
  O11 = @[1, 11]                           # shortcut for hi 15
  Pos = @[0, 1, 4, 5, 6, 9]                # shortcut for 2nd lo 0

var
  lul: Llst = @[Z, Odl, @[], @[], Evl, T7, Odl]             # shortcut lookup lo primary
  luh: Llst = @[Tn, Evh, @[], @[], Evh, T12, Odh, @[], @[],
                Evh, Nin, Odh, @[], @[], Odh, O11, Evh]     # shortcut lookup hi primary
  l2l: Llst = @[Pos, @[], @[], @[], All, @[], All]          # shortcut lookup lo secondary
  l2h: Llst = @[@[], @[], @[], @[], Alh, @[], Alh, @[], @[],
                @[], Alh, @[], @[], @[], Alh, @[], Alh]     # shortcut lookup hi secondary
  chTen: Llst = @[@[0, 2, 5, 8, 9], @[0, 3, 4, 6, 9], @[1, 4, 7, 8],
                  @[2, 3, 5, 8], @[0, 3, 6, 7, 9], @[1, 2, 4, 7],
                  @[2, 5, 6, 8], @[0, 1, 3, 6, 9], @[1, 4, 5, 7]]
  chAH: Llst = @[@[0, 2, 5, 8, 9, 11, 14, 17, 18], @[0, 3, 4, 6, 9, 12, 13, 15, 18],
                 @[1, 4, 7, 8, 10, 13, 16, 17], @[2, 3, 5, 8, 11, 12, 14, 17],
                 @[0, 3, 6, 7, 9, 12, 15, 16, 18], @[1, 2, 4, 7, 10, 11, 13, 16],
                 @[2, 5, 6, 8, 11, 14, 15, 17], @[0, 1, 3, 6, 9, 10, 12, 15, 18],
                 @[1, 4, 5, 7, 10, 13, 14, 16]]

var lu, l2: Llst

func isr(s: int64): int64 {.inline.} =
  ## Return integer square root.
  int64(sqrt(float(s)))

proc isRev(nd: int; f, r: int64): bool =
  ## Recursively determines whether 'r' is the reverse of 'f'.
  let nd = nd - 1
  if f div P[nd] != r mod 10: return false
  if nd < 1: return true
  result = isRev(nd, f mod P[nd], r div 10)

proc recurseLE5(lst: Llst; lv: int) =
  ## Recursive function to evaluate the permutations, no shortcuts.
  if lv == dl:        # Check if on last stage of permutation.
    sum = ac[lv - 1]
    if sum > 0:
      let rt = int64(sqrt(float(sum)))
      if rt * rt == sum: sr.add sum
  else:
    for n in lst[lv]:     # Set up next permutation.
      d[lv] = n
      if lv == 0: ac[0] = pp[0] * n
      else: ac[lv] = ac[lv - 1] + pp[lv] * n   # Update accumulated sum.
      recurseLE5(lst, lv + 1)                  # Recursively call next level.

proc recursehi(lst: var Llst; lv: int) =
  ## Recursive function to evaluate the hi permutations.
  ## Shortcuts added to avoid generating many non-squares, digital root calc added.
  let lv1 = lv - 1
  if lv == dl:    # Check if on last stage of permutation.
    sum = ac[lv1]
    if (0x202021202030213 and (1 shl (sum and 63))) != 0:
      # Test accumulated sum, append to result if square.
      let rt = int64(sqrt(float64(sum)))
      if rt * rt == sum: sr.add sum
  else:
    for n in lst[lv]:     # Set up next permutation.
      d[lv] = n
      if lv == 0:
        ac[0] = pp[0] * n
        dac[0] = Drar[n]    # Update accumulated sum and running dr.
      else:
        ac[lv] = ac[lv1] + pp[lv] * n
        dac[lv] = dac[lv1] + Drar[n]
        if dac[lv] > 8: dec dac[lv], 9
      case lv     # Shortcuts to be performed on designated levels.
      of 0:       # Primary level: set shortcuts for secondary level.
        ln = n
        lst[1] = lu[ln]
        lst[2] = l2[n]
      of 1:       # Secondary level: set shortcuts for tertiary level.
        case ln   # For sums.
        of 5, 15: lst[2] = if n < 10: Evh else: Odh
        of 9: lst[2] = if (n shr 1 and 1) == 0: Evh else: Odh
        of 11: lst[2] = if (n shr 1 and 1) == 1: Evh else: Odh
        else: discard
      else: discard
      if lv == dl - 2:
        # Reduce last round according to dr calc.
        lst[dl - 1] = if odd: chTen[dac[dl - 2]] else: chAH[dac[dl - 2]]
      recursehi(lst, lv + 1)  # Recursively call next level.

proc recurselo(lst: var Llst; lv: int) =
  ## Recursive function to evaluate the lo permutations.
  ## Shortcuts added to avoid generating many non-squares.
  let lv1 = lv - 1
  if lv == dl:    # Check if on last stage of permutation.
    sum = ac[lv1]
    if sum > 0:
      let rt = int64(sqrt(float64(sum)))
      if rt * rt == sum: sr.add sum
  else:
    for n in lst[lv]:     # Set up next permutation.
      d[lv] = n
      if lv == 0: ac[0] = pp[0] * n
      else: ac[lv] = ac[lv1] + pp[lv] * n  # Update accumulated sum.
      case lv     # Shortcuts to be performed on designated levels.
      of 0:       # Primary level: set shortcuts for secondary level.
        ln = n
        lst[1] = lu[ln]
        lst[2] = l2[n]
      of 1:       # Secondary level: set shortcuts for tertiary level.
        case ln   # For difs.
        of 1: lst[2] = if ((n + 9) shr 1 and 1) == 0: Evl else: Odl
        of 5: lst[2] = if n < 0: Evl else: Odl
        else: discard
      else: discard
      recurselo(lst, lv + 1)    # Recursively call next level.

proc listEm(lst: var Llst; plu, pl2: Llst): seq[int64] =
  ## Produces a list of candidate square numbers.
  dl = lst.len
  d = newSeq[int](dl)
  sr.setLen(0)
  lu = plu
  l2 = pl2
  ac = newSeq[int64](dl)
  dac = newSeq[int](dl)
  pp = newSeq[int64](dl)
  # Build coefficients array.
  for i in 0..<dl:
    pp[i] = if lst[0].len > 6: P[nd1 - i] + P[i] else: P[nd1 - i] - P[i]
  # Call appropriate recursive function.
  if nd <= 5: recurseLE5(lst, 0)
  elif lst[0].len > 8: recursehi(lst, 0)
  else: recurselo(lst, 0)
  result = sr

proc reveal(lo, hi: openArray[int64]) =
  ## Reveal whether combining two lists of squares can produce a rare number.
  var s: seq[string]   # Temporary list of results.
  for l in lo:
    for h in hi:
      let r = (h - l) shr 1
      let f = h - r   # Generate all possible fwd & rev candidates from lists.
      if isRev(nd, f, r):
        s.add &"{f:20} {isr(h):11} {isr(l):10}  "
  s.sort()
  if s.len > 0:
    for t in s:
      inc cn
      let tt = if t != s[^1]: "\n" else: ""
      stdout.write &"{cn:2} {t}{tt}"
  else:
    stdout.write &"{\"\":48}"

func formatTime(d: Duration): string =
  var f = d.inMilliseconds
  var s = f div 1000
  f = f mod 1000
  var m = s div 60
  s = s mod 60
  let h = m div 60
  m = m mod 60
  result = &"{h:02}:{m:02}:{s:02}.{f:03}"

var
  lls: Llst = @[Tlo]
  hls: Llst = @[Thi]

var bstart, tstart = now()

echo &"""nth {"forward":>19} {"rt.sum":>11} {"rt.dif":>10}  digs {"block time":>11} {"total time":>13}"""

while nd <= 18:
  if nd > 2:
    if odd:
      hls.add Ten
    else:
      lls.add All
      hls[^1] = Alh
  reveal(listEm(lls, lul, l2l), listEm(hls, luh, l2h))
  if not odd and nd > 5:
    # Restore last element of hls, so that dr shortcut doesn't mess up next nd.
    hls[^1] = Alh
  let bTime = formatTime(now() - bstart)
  let tTime = formatTime(now() - tstart)
  echo &"{nd:2}: {bTime}  {tTime}"
  bstart = now()  # Restart block timing.
  nd1 = nd
  inc nd
  odd = not odd
