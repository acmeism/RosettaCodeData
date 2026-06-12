import strformat, strutils

func isPalindromic(s: string): bool =
  for i in 1..s.len:
    if s[i-1] != s[^i]: return false
  result = true

func isPrime(n: Natural): bool =
  if n < 2: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  return true


var list: seq[string]
for n in 0..<500:
  let h = &"{n:x}"
  if h.isPalindromic and n.isPrime: list.add h

echo "Found ", list.len, " palindromic primes in base 16:"
echo list.join(" ")
