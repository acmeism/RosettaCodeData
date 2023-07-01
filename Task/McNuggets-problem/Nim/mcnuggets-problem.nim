const Limit = 100

var mcnuggets: array[0..Limit, bool]

for a in countup(0, Limit, 6):
  for b in countup(a, Limit, 9):
    for c in countup(b, Limit, 20):
      mcnuggets[c] = true

for n in countdown(Limit, 0):
  if not mcnuggets[n]:
    echo "The largest non-McNuggets number is: ", n
    break
