const Primes = {2, 3, 5, 7, 11, 13, 17, 19}

func digitSum(n: Positive): int =
  ## Return the sum of digits of "n".
  var n = n.Natural
  while n != 0:
    result += n mod 10
    n = n div 10

for n in 5..99:
  let n² = n * n
  if digitSum(n²) in Primes and digitSum(n * n²) in Primes:
    stdout.write n, ' '
echo()
