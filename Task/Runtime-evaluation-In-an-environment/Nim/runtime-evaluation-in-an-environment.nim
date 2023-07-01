import macros, strformat

macro eval(s, x: static[string]): untyped =
  parseStmt(&"let x={x}\n{s}")

echo(eval("x+1", "3.1"))
