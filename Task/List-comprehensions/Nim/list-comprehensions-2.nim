import macros

type ListComprehension = object
var lc*: ListComprehension

macro `[]`*(lc: ListComprehension, x, t): untyped =
  expectLen(x, 3)
  expectKind(x, nnkInfix)
  expectKind(x[0], nnkIdent)
  assert($x[0].strVal == "|")

  result = newCall(
    newDotExpr(
      newIdentNode("result"),
      newIdentNode("add")),
    x[1])

  for i in countdown(x[2].len-1, 0):
    let y = x[2][i]
    expectKind(y, nnkInfix)
    expectMinLen(y, 1)
    if y[0].kind == nnkIdent and $y[0].strVal == "<-":
      expectLen(y, 3)
      result = newNimNode(nnkForStmt).add(y[1], y[2], result)
    else:
      result = newIfStmt((y, result))

  result = newNimNode(nnkCall).add(
    newNimNode(nnkPar).add(
      newNimNode(nnkLambda).add(
        newEmptyNode(),
        newEmptyNode(),
        newEmptyNode(),
        newNimNode(nnkFormalParams).add(
          newNimNode(nnkBracketExpr).add(
            newIdentNode("seq"),
            t)),
        newEmptyNode(),
        newEmptyNode(),
        newStmtList(
          newAssignment(
            newIdentNode("result"),
            newNimNode(nnkPrefix).add(
              newIdentNode("@"),
              newNimNode(nnkBracket))),
          result))))

const n = 20
echo lc[(x,y,z) | (x <- 1..n, y <- x..n, z <- y..n, x*x + y*y == z*z), tuple[a,b,c: int]]
