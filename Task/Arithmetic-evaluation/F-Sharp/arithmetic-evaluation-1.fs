module AbstractSyntaxTree

type Expression =
  | Int    of int
  | Plus   of Expression * Expression
  | Minus  of Expression * Expression
  | Times  of Expression * Expression
  | Divide of Expression * Expression
