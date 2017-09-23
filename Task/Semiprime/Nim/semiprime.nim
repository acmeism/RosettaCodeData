proc isSemiPrime(k: int): string =
 var
  i: int = 2
  compte: int = 0
  x: int = k
 while i<=x and compte<3:
  if (x mod i)==0:
   x = x div i
   compte += 1
  else:
   i += 1
 if compte==2:
  result = "is semi-prime"
 else:
  result = "isn't semi-prime"

for k in 1675..1680:
 echo k," ",isSemiPrime(k)
