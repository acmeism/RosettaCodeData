# naive function calling counter
# TODO consider a more sophisticated condition on counting function callings
# without parenthesis which are common in nim lang. Be aware that the AST of
# object accessor and procedure calling without parenthesis are same.

import macros, tables, strformat, os
proc visitCall(node: NimNode, table: CountTableRef) =
  if node.kind == nnkCall:
    if node[0].kind == nnkDotExpr:
      table.inc($node[0][1])
      visitCall(node[0][0], table)
    else:
      if node[0].kind == nnkBracketExpr:
        if node[0][0].kind == nnkDotExpr:
          table.inc($node[0][0][1])
          visitCall(node[0][0][0], table)
          return
        else:
          table.inc($node[0][0])
          if len(node[0]) > 1:
            for child in node[0][1..^1]:
              visitCall(child, table)
      elif node[0].kind == nnkPar:
        visitCall(node[0], table)
      else:
        table.inc($node[0])
      if len(node) > 1:
        for child in node[1..^1]:
          visitCall(child, table)
  else:
    for child in node.children():
      visitCall(child, table)

static:
  const code = staticRead(expandTilde(&"~/.choosenim/toolchains/nim-{NimVersion}/lib/system.nim"))
  var
    ast = parseStmt(code)
    callCounts = newCountTable[string]()
  ast.visitCall(callCounts)
  sort(callCounts)
  var total = 10
  for ident, times in callCounts.pairs():
    echo(&"{ident} called {times} times")
    total-=1
    if total == 0:
      break
