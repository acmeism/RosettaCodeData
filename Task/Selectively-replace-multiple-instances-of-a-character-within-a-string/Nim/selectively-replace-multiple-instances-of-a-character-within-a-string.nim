import std/tables

type
  # Table of replacements for a character.
  Replacements = Table[int, char]
  # Table mapping characters to their replacement table.
  ReplacementTable = Table[char, Replacements]

const ReplTable = {'a': {1: 'A', 2: 'B', 4: 'C', 5: 'D'}.toTable,
                   'b': {1: 'E'}.toTable,
                   'r': {2: 'F'}.toTable
                  }.toTable

proc replace(text: string; replTable: ReplacementTable): string =
  var counts: Table[char, int]  # Follow count of characters.
  for c in text:
    if c in replTable:
      counts.mgetOrPut(c, 0).inc  # Update count for this char.
      let pos = counts[c]
      result.add replTable[c].getOrDefault(pos, c)
    else:
      result.add c

echo replace("abracadabra", ReplTable)
