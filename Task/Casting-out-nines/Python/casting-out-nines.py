# Casting out Nines
#
# Nigel Galloway: June 27th., 2012,
#
def CastOut(Base=10, Start=1, End=999999):
  ran = [y for y in range(Base-1) if y%(Base-1) == (y*y)%(Base-1)]
  x,y = divmod(Start, Base-1)
  while True:
    for n in ran:
      k = (Base-1)*x + n
      if k < Start:
        continue
      if k > End:
        return
      yield k
    x += 1

for V in CastOut(Base=16,Start=1,End=255):
  print(V, end=' ')
