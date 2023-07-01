import lenientops

func jaro(s1, s2: string): float =

  if s1.len == 0 and s2.len == 0: return 1
  if s1.len == 0 or s2.len == 0: return 0

  let matchDistance = max(s1.len, s2.len) div 2 - 1
  var s1Matches = newSeq[bool](s1.len)
  var s2Matches = newSeq[bool](s2.len)
  var matches = 0
  for i in 0..s1.high:
    for j in max(0, i - matchDistance)..min(i + matchDistance, s2.high):
      if not s2Matches[j] and s1[i] == s2[j]:
        s1Matches[i] = true
        s2Matches[j] = true
        inc matches
        break
  if matches == 0: return 0

  var transpositions = 0.0
  var k = 0
  for i in ..s1.high:
    if not s1Matches[i]: continue
    while not s2Matches[k]: inc k
    if s1[i] != s2[k]: transpositions += 0.5
    inc k

  result = (matches / s1.len + matches / s2.len + (matches - transpositions) / matches) / 3

echo jaro("MARTHA", "MARHTA")
echo jaro("DIXON", "DICKSONX")
echo jaro("JELLYFISH", "SMELLYFISH")
