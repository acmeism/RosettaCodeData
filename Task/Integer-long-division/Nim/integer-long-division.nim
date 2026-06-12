import strformat, strutils, tables
import bignum

proc divide(m, n: Int): tuple[repr: string; cycle: string; period: int] =
  doAssert m >= 0, "m must not be negative."
  doAssert n > 0, "n must be positive."

  var quotient = &"{m div n}."
  var c = m mod n * 10
  var zeros = 0
  while c > 0 and c < n:
    c *= 10
    quotient &= '0'
    inc zeros

  var digits = ""
  var passed: Table[string, int]
  var i = 0
  while true:
    let cs = $c
    if cs in passed:
      let idx = passed[cs]
      let prefix = digits[0..<idx]
      var cycle = digits[idx..^1]
      var repr = &"{quotient}{prefix}({cycle})"
      repr = repr.replace("(0)", "").strip(leading = false, trailing = true, {'.'})
      let index = repr.find('(')
      if index < 0: return (repr, "", 0)
      repr = repr.multiReplace(("(", ""), (")", ""))
      for _ in 1..zeros:
        if cycle[^1] == '0':
          repr.setLen(repr.len - 1)
          cycle = '0' & cycle[0..^2]
        else:
          break
      return (repr & "...", cycle, cycle.len)

    let q = c div n
    let r = c mod n
    passed[cs] = i
    digits &= $q
    inc i
    c = r * 10


const Tests = [("0", "1"), ("1", "1"), ("1", "3"), ("1", "7"),
               ("83","60"), ("1", "17"), ("10", "13"), ("3227", "555"),
               ("476837158203125", "9223372036854775808"), ("1", "149"), ("1", "5261")]

for test in Tests:
  let a = newInt(test[0])
  let b = newInt(test[1])
  let (repr, cycle, period) = divide(a, b)
  echo &"{a}/{b} = {repr}"
  echo &"Cycle is <{cycle}>"
  echo &"Period is {period}\n"
