const Primes = {2, 3, 5, 7, 11, 13, 17}

proc digits(n: 100..999): array[3, int] =
  [n div 100, n div 10 mod 10, n mod 10]

var count = 0
for n in 101..<500:
  let d = n.digits
  if d[0] + d[1] in Primes and d[1] + d[2] in Primes:
    inc count
    stdout.write n, if count mod 13 == 0: '\n' else: ' '
