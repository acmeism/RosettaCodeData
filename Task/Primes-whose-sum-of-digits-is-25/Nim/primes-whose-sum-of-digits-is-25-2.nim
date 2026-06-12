import std/monotimes, strformat, strutils
import bignum

func sum25(p: string; rm, res: Natural): Natural =
  result = res
  if rm == 0:
    if p[^1] in "1379" and probablyPrime(newInt(p), 25) != 0:
      inc result
  else:
    for i in 1..min(rm, 9):
      result = sum25(p & chr(i + ord('0')), rm - i, result)

let t0 = getMonoTime()
let count = $sum25("", 25, 0)
echo &"There are {count.insertSep()} primes whose digits sum to 25 without any zero digits."
echo "\nExecution time: ", getMonoTime() - t0
