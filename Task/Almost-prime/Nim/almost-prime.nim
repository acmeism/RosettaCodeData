proc prime(k: int, listLen: int): seq[int] =
 result = @[]
 var
  test: int = 2
  curseur: int = 0
 while curseur < listLen:
  var
   i: int = 2
   compte = 0
   n = test
  while i <= n:
   if (n mod i)==0:
    n = n div i
    compte += 1
   else:
    i += 1
  if compte == k:
   result.add(test)
   curseur += 1
  test += 1

for k in 1..5:
 echo "k = ",k," : ",prime(k,10)
