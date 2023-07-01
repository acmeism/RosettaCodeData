import strutils, tables

proc runUTM(state, halt, blank: string, tape: seq[string] = @[],
            rules: seq[seq[string]]) =
  var
    st = state
    pos = 0
    tape = tape
    rulesTable: Table[tuple[s0, v0: string], tuple[v1, dr, s1: string]]

  if tape.len == 0: tape = @[blank]
  if pos < 0: pos += tape.len
  assert pos in 0..tape.high

  for r in rules:
    assert r.len == 5
    rulesTable[(r[0], r[1])] = (r[2], r[3], r[4])

  while true:
    stdout.write st, '\t'
    for i, v in tape:
      stdout.write if i == pos: '[' & v & ']' else: ' ' & v & ' '
    echo()

    if st == halt: break
    if not rulesTable.hasKey((st, tape[pos])): break

    let (v1, dr, s1) = rulesTable[(st, tape[pos])]
    tape[pos] = v1
    if dr == "left":
      if pos > 0: dec pos
      else: tape.insert blank
    if dr == "right":
      inc pos
      if pos >= tape.len: tape.add blank
    st = s1

echo "incr machine\n"
runUTM(halt  = "qf",
       state = "q0",
       tape  = "1 1 1".split,
       blank = "B",
       rules = @["q0 1 1 right q0".splitWhitespace,
                 "q0 B 1 stay  qf".splitWhitespace])

echo "\nbusy beaver\n"
runUTM(halt  = "halt",
       state = "a",
       blank = "0",
       rules = @["a 0 1 right b".splitWhitespace,
                 "a 1 1 left  c".splitWhitespace,
                 "b 0 1 left  a".splitWhitespace,
                 "b 1 1 right b".splitWhitespace,
                 "c 0 1 left  b".splitWhitespace,
                 "c 1 1 stay  halt".splitWhitespace])

echo "\nsorting test\n"
runUTM(halt  = "STOP",
       state = "A",
       blank = "0",
       tape  = "2 2 2 1 2 2 1 2 1 2 1 2 1 2".split,
       rules = @["A 1 1 right A".splitWhitespace,
                 "A 2 3 right B".splitWhitespace,
                 "A 0 0 left  E".splitWhitespace,
                 "B 1 1 right B".splitWhitespace,
                 "B 2 2 right B".splitWhitespace,
                 "B 0 0 left  C".splitWhitespace,
                 "C 1 2 left  D".splitWhitespace,
                 "C 2 2 left  C".splitWhitespace,
                 "C 3 2 left  E".splitWhitespace,
                 "D 1 1 left  D".splitWhitespace,
                 "D 2 2 left  D".splitWhitespace,
                 "D 3 1 right A".splitWhitespace,
                 "E 1 1 left  E".splitWhitespace,
                 "E 0 0 right STOP".splitWhitespace])
