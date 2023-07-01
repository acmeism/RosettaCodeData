# Recursive
proc multifact(n, deg: int): int =
  result = (if n <= deg: n else: n * multifact(n - deg, deg))

# Iterative
proc multifactI(n, deg: int): int =
  result = n
  var n = n
  while n >= deg + 1:
    result *= n - deg
    n -= deg

for i in 1..5:
  stdout.write "Degree ", i, ": "
  for j in 1..10:
    stdout.write multifactI(j, i), " "
  stdout.write('\n')
