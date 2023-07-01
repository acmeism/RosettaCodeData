import sequtils

func min(a, b, c: int): int {.inline.} = min(a, min(b, c))

proc levenshteinDistance(s1, s2: string): int =
  var (s1, s2) = (s1, s2)

  if s1.len > s2.len:
    swap s1, s2

  var distances = toSeq(0..s1.len)

  for i2, c2 in s2:
    var newDistances = @[i2+1]
    for i1, c1 in s1:
      if c1 == c2:
        newDistances.add(distances[i1])
      else:
        newDistances.add(1 + min(distances[i1], distances[i1+1], newDistances[newDistances.high]))

    distances = newDistances
  result = distances[distances.high]

echo levenshteinDistance("kitten","sitting")
echo levenshteinDistance("rosettacode","raisethysword")
