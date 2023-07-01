import math, strutils, strformat

#---------------------------------------------------------------------------------------------------

func ebanCount(p10: Natural): Natural =
  ## Return the count of eban numbers 1..10^p10.
  let
    n = p10 - p10 div 3
    p5 = n div 2
    p4 = (n + 1) div 2
  result = 5^p5 * 4^p4 - 1

#---------------------------------------------------------------------------------------------------

func eban(n: Natural): bool =
  ## Return true if n is an eban number (only fully tested to 10e9).
  if n == 0: return false
  var n = n
  while n != 0:
    let thou = n mod 1000
    if thou div 100 != 0: return false
    if thou div 10 notin {0, 3, 4, 5, 6}: return false
    if thou mod 10 notin {0, 2, 4, 6}: return false
    n = n div 1000
  result = true

#———————————————————————————————————————————————————————————————————————————————————————————————————

var s: seq[Natural]
for i in 0..1000:
  if eban(i): s.add(i)
echo fmt"Eban to 1000: {s.join("", "")} ({s.len} items)"

s.setLen(0)
for i in 1000..4000:
  if eban(i): s.add(i)
echo fmt"Eban 1000..4000: {s.join("", "")} ({s.len} items)"

import times
let t0 = getTime()
for i in 0..21:
  echo fmt"ebanCount(10^{i}): {ebanCount(i)}"
echo ""
echo fmt"Time: {getTime() - t0}"
