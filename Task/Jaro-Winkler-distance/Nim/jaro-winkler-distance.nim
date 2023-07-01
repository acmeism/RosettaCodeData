import lenientops

func jaroSim(s1, s2: string): float =

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


func jaroWinklerDist(s, t: string): float =
  let ls = s.len
  let lt = t.len
  var lmax = if ls < lt: ls else: lt
  if lmax > 4: lmax = 4
  var l = 0
  for i in 0..<lmax:
    if s[i] == t[i]: inc l
  let js = jaroSim(s, t)
  let p = 0.1
  let ws = js + float(l) * p * (1 - js)
  result = 1 - ws


when isMainModule:

  import algorithm, sequtils, strformat

  type Wd = tuple[word: string; dist: float]

  func `<`(w1, w2: Wd): bool =
    if w1.dist < w2.dist: true
    elif w1.dist == w2.dist: w1.word < w2.word
    else: false

  const Misspelt = ["accomodate", "definately", "goverment", "occured",
                    "publically", "recieve", "seperate", "untill", "wich"]

  let words = toSeq("unixdict.txt".lines)
  for ms in Misspelt:
    var closest: seq[Wd]
    for word in words:
      if word.len == 0: continue
      let jwd = jaroWinklerDist(ms, word)
      if jwd < 0.15:
        closest.add (word, jwd)
    echo "Misspelt word: ", ms, ":"
    closest.sort()
    for i, c in closest:
      echo &"{c.dist:0.4f} {c.word}"
      if i == 5: break
    echo()
