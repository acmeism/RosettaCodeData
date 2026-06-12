for i in range(65,123):
  check = 1
  for j in range(2,i):
    if i%j == 0:
     check = 0
  if check==1:
   print(chr(i),end='')
