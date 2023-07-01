import std/strformat
import integers

func compress(str: string; size: int): string =
  if str.len <= 2 * size: str
  else: &"{str[0..<size]}...{str[^size..^1]} ({str.len} digits)"

echo "First 24 Wagstaff primes:"
let One = newInteger(1)
var count = 0
var p = 3
while count < 24:
  if p.isPrime:
    let n = (One shl p + 1) div 3
    if n.isPrime:
      inc count
      echo &"{p:4}: {compress($n, 15)}"
  inc p, 2
