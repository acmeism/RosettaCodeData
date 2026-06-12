import std/strformat
import integers

func reversed(n: Integer): Integer =
  ## Return the "reversed" value of "n".
  result = newInteger()
  var n = n
  while n != 0:
    result = 10 * result + n mod 10
    n = n div 10

iterator fib(): Integer =
  ## Yield the successive values of Fibonacci sequence.
  var prev, curr = newInteger(1)
  yield prev
  while true:
    yield curr
    swap curr, prev
    curr += prev

func compressed(str: string; size: int): string =
  ## Return a compressed value for long strings of digits.
  if str.len <= 2 * size: str
  else: &"{str[0..<size]}...{str[^size..^1]}"

func digitCount(s: string): string =
  ## Return the string which describes the number of digits.
  result = $s.len & " digit"
  if s.len > 1: result.add 's'

echo "First 25 Iccanobif primes:"
var count = 0
for n in fib():
  let r = reversed(n)
  if r.isPrime:
    inc count
    let s = $r
    echo &"{count:>2}: {s.compressed(20)} ({s.digitCount()})"
    if count == 25: break
