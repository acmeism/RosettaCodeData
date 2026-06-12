import std/strformat
import integers

func compressed(str: string; size: int): string =
  ## Return a compressed value for long strings of digits.
  if str.len <= 2 * size: str
  else: &"{str[0..<size]}...{str[^size..^1]} ({str.len} digits)"

echo "  n     m    prime"
for n in 1..400:
  var m = 0
  var term = newInteger(n)
  while true:
    if isPrime(term + 1):
      echo &"{n:3}  {m:4}    {compressed($(term + 1), 10)}"
      break
    inc m
    term *= 2
