proc isSemiPrime(k: int): bool =
 var
  i = 2
  count = 0
  x = k
 while i <= x and count < 3:
  if x mod i == 0:
   x = x div i
   inc count
  else:
   inc i
 result = count == 2

for k in 1675..1680:
 echo k, (if k.isSemiPrime(): " is" else: " isn’t"), " semi-prime"
