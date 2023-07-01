import tables, strutils

const nPrec = 9

let ops: Table[string, tuple[prec: int, rAssoc: bool]] =
  { "^": (4, true)
  , "*": (3, false)
  , "/": (3, false)
  , "+": (2, false)
  , "-": (2, false)
  }.toTable

proc parseRPN(e: string) =
  echo "postfix: ", e
  var stack = newSeq[tuple[prec: int, expr: string]]()

  for tok in e.split:
    echo "Token: ", tok
    if ops.hasKey tok:
      let op = ops[tok]
      let rhs = stack.pop
      var lhs = stack.pop

      if lhs.prec < op.prec or (lhs.prec == op.prec and op.rAssoc):
        lhs.expr = "(" & lhs.expr & ")"

      lhs.expr.add " " & tok & " "

      if rhs.prec < op.prec or (rhs.prec == op.prec and not op.rAssoc):
        lhs.expr.add "(" & rhs.expr & ")"
      else:
        lhs.expr.add rhs.expr

      lhs.prec = op.prec
      stack.add lhs
    else:
      stack.add((nPrec, tok))

    for f in stack:
      echo "    ", f.prec, " ", f.expr

  echo "infix: ", stack[0].expr

for test in ["3 4 2 * 1 5 - 2 3 ^ ^ / +", "1 2 + 3 4 + ^ 5 6 + ^"]:
  test.parseRPN
