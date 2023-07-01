import strformat, tables

type
  Data1 = tuple[value: int; key: string]
  Data2 = tuple[key: string; value: string]

proc `$`(d: Data1 | Data2): string = &"({d[0]}, {d[1]})"

iterator hashJoin(table1: openArray[Data1]; table2: openArray[Data2]): tuple[a: Data1; b: Data2] =
  # Hash phase.
  var h: Table[string, seq[Data1]]
  for s in table1:
    h.mgetOrPut(s.key, @[]).add(s)
  # Join phase.
  for r in table2:
    for s in h[r.key]:
      yield (s, r)


let table1 = [(27, "Jonah"),
              (18, "Alan"),
              (28, "Glory"),
              (18, "Popeye"),
              (28, "Alan")]

let table2 = [("Jonah", "Whales"),
              ("Jonah", "Spiders"),
              ("Alan", "Ghosts"),
              ("Alan", "Zombies"),
              ("Glory", "Buffy")]

for row in hashJoin(table1, table2):
  echo row.a, " ", row.b
