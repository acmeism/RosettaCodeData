proc example =
  echo "Example"

# Ordinary procedure
proc repeatProc(fn: proc, n: int) =
  for x in 0..<n:
    fn()

repeatProc(example, 4)

# Template (code substitution), simplest form of metaprogramming
# that Nim has
template repeatTmpl(n: int, body: untyped): untyped =
  for x in 0..<n:
    body

# This gets rewritten into a for loop
repeatTmpl 4:
  example()

import std/macros
# A macro which takes some code block and returns code
# with that code block repeated n times. Macros run at
# compile-time
macro repeatMacro(n: static[int], body: untyped): untyped =
  result = newStmtList()

  for x in 0..<n:
    result.add body

# This gets rewritten into 4 calls to example()
# at compile-time
repeatMacro 4:
  example()
