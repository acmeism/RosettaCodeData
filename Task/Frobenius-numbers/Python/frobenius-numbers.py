#!/usr/bin/python

def isPrime(v):
  if v <= 1:
    return False
  if v < 4:
    return True
  if v % 2 == 0:
    return False
  if v < 9:
    return True
  if v % 3 == 0:
    return False
  else:
    r = round(pow(v,0.5))
    f = 5
    while f <= r:
      if v % f == 0 or v % (f + 2) == 0:
        return False
      f += 6
    return True

pn = 2
n = 0
for i in range(3, 9999, 2):
  if isPrime(i):
    n += 1
    f = (pn * i) - pn - i
    if f > 10000:
      break
    print (n, ' => ', f)
    pn = i
