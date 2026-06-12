import std/strutils

type

  ExpressionPrintingVisitor = object

  Expression = ref object of RootObj

  Literal = ref object of Expression
    value: float

  Addition = ref object of Expression
    left, right: Expression


# Expression procedures and methods.

method accept(e: Expression; v: ExpressionPrintingVisitor) {.base.} =
  raise newException(CatchableError, "Method without implementation override")

method getValue(e: Expression): float {.base.} =
  raise newException(CatchableError, "Method without implementation override")


# ExpressionPrintingVisitor procedures.

proc printLiteral(v: ExpressionPrintingVisitor; literal: Literal) =
  echo literal.value

proc printAddition(v: ExpressionPrintingVisitor; addition: Addition) =
  let leftValue = addition.left.getValue()
  let rightValue = addition.right.getValue()
  let sum = addition.getValue()
  echo "$1 + $2 = $3".format(leftValue, rightValue, sum)


# Literal procedure and methods.
proc newLiteral(value: float): Literal =
  Literal(value: value)

method accept(lit: Literal; v: ExpressionPrintingVisitor) =
  v.printLiteral(lit)

method getValue(lit: Literal): float = lit.value


# Addition procedure and methods.
proc newAddition(left, right: Expression): Addition =
  Addition(left: left, right: right)

method accept(a: Addition; v: ExpressionPrintingVisitor) =
  a.left.accept(v)
  a.right.accept(v)
  v.printAddition(a)

method getValue(a: Addition): float =
  a.left.getValue() + a.right.getValue()


proc main() =
  # Emulate 1 + 2 + 3.
  let e = newAddition(
            newAddition(newLiteral(1), newLiteral(2)),
            newLiteral(3))
  var printingVisitor: ExpressionPrintingVisitor
  e.accept(printingVisitor)

main()
