# 15 puzzle.

import strformat
import times

const
  Nr = [3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3]
  Nc = [3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2]

type

  Solver = object
    n: int
    np: int
    n0: array[100, int]
    n2: array[100, uint64]
    n3: array[100, char]
    n4: array[100, int]

  Value = range[0..15]

# Forward definition.
proc fN(s: var Solver): bool

#---------------------------------------------------------------------------------------------------

proc fI(s: var Solver) =

  let n = s.n
  let g = (11 - s.n0[n]) * 4
  let a = s.n2[n] and uint(15 shl g)
  s.n0[n + 1] = s.n0[n] + 4
  s.n2[n + 1] = s.n2[n] - a + a shl 16
  s.n3[n + 1] = 'd'
  s.n4[n + 1] = s.n4[n] + ord(Nr[a shr g] > s.n0[n] div 4)

#---------------------------------------------------------------------------------------------------

proc fG(s: var Solver) =

  let n = s.n
  let g = (19 - s.n0[n]) * 4
  let a = s.n2[n] and uint(15 shl g)
  s.n0[n + 1] = s.n0[n] - 4
  s.n2[n + 1] = s.n2[n] - a + a shr 16
  s.n3[n + 1] = 'u'
  s.n4[n + 1] = s.n4[n] + ord(Nr[a shr g] < s.n0[n] div 4)

#---------------------------------------------------------------------------------------------------

proc fE(s: var Solver) =

  let n = s.n
  let g = (14 - s.n0[n]) * 4
  let a = s.n2[n] and uint(15 shl g)
  s.n0[n + 1] = s.n0[n] + 1
  s.n2[n + 1] = s.n2[n] - a + a shl 4
  s.n3[n + 1] = 'r'
  s.n4[n + 1] = s.n4[n] + ord(Nc[a shr g] > s.n0[n] mod 4)

#---------------------------------------------------------------------------------------------------

proc fL(s: var Solver) =

  let n = s.n
  let g = (16 - s.n0[n]) * 4
  let a = s.n2[n] and uint(15 shl g)
  s.n0[n + 1] = s.n0[n] - 1
  s.n2[n + 1] = s.n2[n] - a + a shr 4
  s.n3[n + 1] = 'l'
  s.n4[n + 1] = s.n4[n] + ord(Nc[a shr g] < s.n0[n] mod 4)

#---------------------------------------------------------------------------------------------------

proc fY(s: var Solver): bool =

  if s.n2[s.n] == 0x123456789abcdef0'u:
    return true
  if s.n4[s.n] <= s.np:
    return s.fN()

#---------------------------------------------------------------------------------------------------

proc fN(s: var Solver): bool =

  let n = s.n
  if s.n3[n] != 'u' and s.n0[n] div 4 < 3:
    s.fI
    inc s.n
    if s.fY(): return true
    dec s.n
  if s.n3[n] != 'd' and s.n0[n] div 4 > 0:
    s.fG()
    inc s.n
    if s.fY(): return true
    dec s.n
  if s.n3[n] != 'l' and s.n0[n] mod 4 < 3:
    s.fE()
    inc s.n
    if s.fY(): return true
    dec s.n
  if s.n3[n] != 'r' and s.n0[n] mod 4 > 0:
    s.fL()
    inc s.n
    if s.fY(): return true
    dec s.n

#---------------------------------------------------------------------------------------------------

proc initSolver(values: array[16, Value]): Solver {.noInit.} =

  result.n = 0
  result.np = 0
  result.n0[0] = values.find(0)
  result.n2[0] = (var tmp = 0'u; for val in values: tmp = tmp shl 4 or uint(val); tmp)
  result.n4[0] = 0

#---------------------------------------------------------------------------------------------------

proc run(s: var Solver) =

  while not s.fY():
    inc s.np
  stdout.write(fmt"Solution found with {s.n} moves: ")
  for g in 1..s.n:
    stdout.write(s.n3[g])
  stdout.write(".\n")

#---------------------------------------------------------------------------------------------------

proc toString(d: Duration): string =
  # Custom representation of a duration.
  const Plural: array[bool, string] = ["", "s"]
  var ms = d.inMilliseconds
  for (label, d) in {"hour": 3_600_000, "minute": 60_000, "second": 1_000, "millisecond": 1}:
    let val = ms div d
    if val > 0:
      result.add($val & ' ' & label & Plural[val > 1])
      ms = ms mod d
      if ms > 0: result.add(' ')
