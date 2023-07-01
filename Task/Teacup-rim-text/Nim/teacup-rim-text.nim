import sequtils, sets, sugar

let words = collect(initHashSet, for word in "unixdict.txt".lines: {word})

proc rotate(s: var string) =
  let first = s[0]
  for i in 1..s.high: s[i - 1] = s[i]
  s[^1] = first

var result: seq[string]
for word in "unixdict.txt".lines:
  if word.len >= 3:
    block checkWord:
      var w = word
      for _ in 1..w.len:
        w.rotate()
        if w notin words or w in result:
          # Not present in dictionary or already encountered.
          break checkWord
      if word.anyIt(it != word[0]):
        # More then one letter.
        result.add word

for word in result:
  var w = word
  stdout.write w
  for _ in 2..w.len:
    w.rotate()
    stdout.write " → ", w
  echo()
