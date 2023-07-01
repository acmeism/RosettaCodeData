proc consolidate(sets: varargs[set[char]]): seq[set[char]] =
  if len(sets) < 2:
    return @sets
  var (r, b) = (@[sets[0]], consolidate(sets[1..^1]))
  for x in b:
    if len(r[0] * x) != 0:
      r[0] = r[0] + x
    else:
      r.add(x)
  r

echo consolidate({'A', 'B'}, {'C', 'D'})
echo consolidate({'A', 'B'}, {'B', 'D'})
echo consolidate({'A', 'B'}, {'C', 'D'}, {'D', 'B'})
echo consolidate({'H', 'I', 'K'}, {'A', 'B'}, {'C', 'D'}, {'D', 'B'}, {'F', 'G', 'H'})
