import macros

proc newIfElse(c, t, e): PNimNode {.compiletime.} =
  result = newIfStmt((c, t))
  result.add(newNimNode(nnkElse).add(e))

macro if2(x, y: expr; z: stmt): stmt {.immediate.} =
  var parts: array[4, PNimNode]
  for i in parts.low .. parts.high:
    parts[i] = newNimNode(nnkDiscardStmt).add(nil)

  assert z.kind == nnkStmtList
  assert z.len <= 4

  for i in 0 .. <z.len:
    assert z[i].kind == nnkCall
    assert z[i].len == 2

    var j = 0

    case $z[i][0].ident
    of "then":  j = 0
    of "else1": j = 1
    of "else2": j = 2
    of "else3": j = 3
    else: assert false

    parts[j] = z[i][1].last

  result = newIfElse(x,
    newIfElse(y, parts[0], parts[1]),
    newIfElse(y, parts[2], parts[3]))

if2 2 > 1, 3 < 2:
  then:
    echo "1"
  else1:
    echo "2"
  else2:
    echo "3"
  else3:
    echo "4"

# Missing cases are supported:
if2 2 > 1, 3 < 2:
  then:
    echo "1"
  else2:
    echo "3"
  else3:
    echo "4"

# Order can be swapped:
if2 2 > 1, 3 < 2:
  then:
    echo "1"
  else2:
    echo "3"
  else1:
    echo "2"
  else3:
    echo "4"
