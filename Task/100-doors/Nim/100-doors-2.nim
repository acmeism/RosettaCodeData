var isOpen: array[1..100, bool]

for pass in countup(1, 100):
  for door in countup(pass,100,pass):
    isOpen[door] = not isOpen[door]

for i in countup(1, 100):
  if isOpen[i]:
    echo("Door ",i," is open.")
