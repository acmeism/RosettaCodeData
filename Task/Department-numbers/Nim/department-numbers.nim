type Solution = tuple[p, s, f: int]

iterator solutions(max, total: Positive): Solution =
  for p in countup(2, max, 2):
    for s in 1..max:
      if s == p: continue
      let f = total - p - s
      if f notin [p, s] and f in 1..max:
        yield (p, s, f)

echo "P S F"
for sol in solutions(7, 12):
  echo sol.p, " ", sol.s, " ", sol.f
