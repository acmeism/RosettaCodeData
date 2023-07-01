var primes = newSeq[int]()

proc getPrime(idx: int): int =
  if idx >= primes.len:
    if primes.len == 0:
      primes.add 2
      primes.add 3

    var last = primes[primes.high]
    while idx >= primes.len:
      last += 2
      for i, p in primes:
        if p * p > last:
          primes.add last
          break
        if last mod p == 0:
          break

  return primes[idx]

for x in 1 ..< int32.high.int:
  stdout.write x, " = "
  var n = x
  var first = true

  for i in 0 ..< int32.high:
    let p = getPrime(i)
    while n mod p == 0:
      n = n div p
      if not first: stdout.write " x "
      first = false
      stdout.write p

    if n <= p * p:
      break

  if first > 0: echo n
  elif n > 1:   echo " x ", n
  else:         echo ""
