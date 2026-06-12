func isPrime(n: Natural): bool =
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  var step = 2
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, step
    step = 6 - step
  return true

func divisors(n: Positive): seq[int] =
  for d in 2..<n:
    if n mod d == 0:
      result.add d

func isCalmoNumber(n: Positive): bool =
  let d = n.divisors
  if d.len == 0 or d.len mod 3 != 0:
    return false
  for i in countup(0, d.high, 3):
    if not isPrime(d[i] + d[i + 1] + d[i + 2]):
      return false
  return true

for n in 1..1000:
  if n.isCalmoNumber:
    stdout.write ' ', n
echo()
