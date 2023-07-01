import algorithm, strutils


proc orderDisjoint(m, n: string): string =

  # Build the list of items.
  var m = m.splitWhitespace()
  let n = n.splitWhitespace()

  # Find the indexes of items to replace.
  var indexes: seq[int]
  for item in n:
    let idx = m.find(item)
    if idx >= 0:
      indexes.add idx
      m[idx] = ""   # Set to empty string for next searches.
  indexes.sort()

  # Do the replacements.
  for i, idx in indexes:
    m[idx] = n[i]

  result = m.join(" ")


when isMainModule:

  template process(a, b: string) =
    echo a, " | ", b, " → ", orderDisjoint(a, b)

  process("the cat sat on the mat", "mat cat")
  process("the cat sat on the mat", "cat mat")
  process("A B C A B C A B C", "C A C A")
  process("A B C A B D A B E", "E A D A")
  process("A B", "B")
  process("A B", "B A")
  process("A B B A", "B A")
