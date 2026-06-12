import strformat, strutils

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
  result = true

# Build set of prime characters.
const PrimeChars = static:
                     var pchars: set[char]
                     for c in Letters:
                       if ord(c).isPrime: pchars.incl c
                     pchars

var count = 0
for word in "unixdict.txt".lines:
  if word.allCharsInSet(PrimeChars):
    inc count
    echo &"{count:2}: {word}"
