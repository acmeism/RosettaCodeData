import std/[strformat, strutils]

func kmpTable(w: string): seq[int] =
  ## Build the partial match table for "w".
  result.setLen w.len + 1
  var pos = 1
  var cnd = 0
  result[0] = -1
  while pos < w.len:
    if w[pos] == w[cnd]:
      result[pos] = result[cnd]
    else:
      result[pos] = cnd
      while cnd >= 0 and w[pos] != w[cnd]:
        cnd = result[cnd]
    inc pos
    inc cnd
  result[pos] = cnd

func kmpSearch(s, w: string): seq[int] =
  ## Return the positions of "w" ins "s".
  var j, k = 0
  let t = kmpTable(w)
  while j < s.len:
    if w[k] == s[j]:
      inc j
      inc k
      if k == w.len:
        result.add j - k
        k = t[k]
    else:
      k = t[k]
      if k < 0:
        inc j
        inc k


const
  Texts = ["GCTAGCTCTACGAGTCTA",
           "GGCTATAATGCGTA",
           "there would have been a time for such a word",
           "needle need noodle needle",
           "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuth" &
             "usesanimaginarycomputertheMIXanditsassociatedmachinecodeandassembly" &
             "languagestoillustratetheconceptsandalgorithmsastheyarepresented",
           "Nearby farms grew a half acre of alfalfa on the dairy's behalf, " &
             "with bales of all that alfalfa exchanged for milk."
          ]

  # Couples (pattern, index of text to use).
  Patterns = {"TCTA": 0, "TAATAAA": 1, "word": 2, "needle": 3, "put": 4, "and": 4, "alfalfa": 5}

for i, text in Texts:
  echo &"Text{i+1} = {text}"
echo()

for i, (pattern, j) in Patterns:
  let indices = Texts[j].kmpSearch(pattern)
  if indices.len > 0:
    echo &"Found “{pattern}” in “Text{j+1}” at indices {indices.join(\", \")}."
  else:
    echo &"Not found “{pattern}” in “Text{j+1}”."
