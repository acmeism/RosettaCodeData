#ZigZag
#
# Nigel Galloway: June 7th., 2012,
#
COLS = 9
def CX(x, ran):
  while True:
    x += 2 * next(ran)
    yield x
    x += 1
    yield x
ran = []
d = -1
for V in CX(1,iter(list(range(0,COLS,2)) + list(range(COLS-1-COLS%2,0,-2)))):
  ran.append(iter(range(V, V+COLS*d, d)))
  d *= -1
for x in range(0,COLS):
  for y in range(x, x+COLS):
    print(repr(next(ran[y])).rjust(3), end = ' ')
  print()
