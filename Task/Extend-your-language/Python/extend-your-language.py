a, b = 1, 0

if (c1 := a == 1) and (c2 := b == 3):
  print('a = 1 and b = 3')
elif c1:
  print('a = 1 and b <> 3')
elif c2:
  print('a <> 1 and b = 3')
else:
  print('a <> 1 and b <> 3')
