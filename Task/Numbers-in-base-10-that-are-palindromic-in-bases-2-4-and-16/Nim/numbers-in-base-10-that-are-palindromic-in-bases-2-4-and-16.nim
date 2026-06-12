import strutils, sugar

type Digit = 0..15

func toBase(n: Natural; b: Positive): seq[Digit] =
  if n == 0: return @[Digit 0]
  var n = n
  while n != 0:
    result.add n mod b
    n = n div b

func isPalindromic(s: seq[Digit]): bool =
  for i in 1..(s.len div 2):
    if s[i-1] != s[^i]: return false
  result = true

let list = collect(newSeq):
             for n in 0..<25_000:
               if n.toBase(2).isPalindromic and
                  n.toBase(4).isPalindromic and
                  n.toBase(16).isPalindromic: n

echo "Found ", list.len, " numbers which are palindromic in bases 2, 4 and 16:"
echo list.join(" ")
