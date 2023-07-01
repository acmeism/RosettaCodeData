import macros

macro product(args: varargs[typed]): untyped =
  ## Macro to generate the code to build the product of several sequences.

  let t = args[0].getType()
  if t.kind != nnkBracketExpr or t[0].kind != nnkSym or $t[0] != "seq":
    error("Arguments must be sequences", args)

  # Build the result type i.e. a tuple with "args.len" elements.
  # Fields are named "f0", "f1", etc.
  let tupleTyNode = newNimNode(nnkTupleTy)
  for idx, arg in args:
    let identDefsNode = newIdentDefs(ident('f' & $idx), arg.getType()[1])
    tupleTyNode.add(identDefsNode)

  # Build the nested for loops with counter "i0", "i1", etc.
  var stmtListNode = newStmtList()
  let loopsNode = nnkForStmt.newTree(ident("i0"), ident($args[0]), stmtListNode)
  var idx = 0
  for arg in args[1..^1]:
    inc idx
    let loopNode = nnkForStmt.newTree(ident('i' & $idx), ident($arg))
    stmtListNode.add(loopNode)
    stmtListNode = newStmtList()
    loopNode.add(stmtListNode)

  # Build the instruction "result.add(i1, i2,...)".
  let parNode = newPar()
  let addNode = newCall(newDotExpr(ident("result"), ident("add")), parNode)
  for i, arg in args:
    parNode.add(ident('i' & $i))
  stmtListNode.add(addNode)

  # Build the tree.
  result = nnkStmtListExpr.newTree(
             nnkVarSection.newTree(
               newIdentDefs(
                 ident("result"),
                 nnkBracketExpr.newTree(ident("seq"), tupleTyNode))),
               loopsNode,
             ident("result"))

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import strformat
  import strutils

  #-------------------------------------------------------------------------------------------------

  proc `$`[T: tuple](t: T): string =
    ## Overloading of `$` to display a tuple without the field names.
    result = "("
    for f in t.fields:
      result.addSep(", ", 1)
      result.add($f)
    result.add(']')

  proc `$$`[T](s: seq[T]): string =
    ## New operator to display a sequence using mathematical set notation.
    result = "{"
    for item in s:
      result.addSep(", ", 1)
      result.add($item)
    result.add('}')

  #-------------------------------------------------------------------------------------------------

  var a = @[1, 2]
  var b = @['a', 'b']
  var c = @[false, true]
  echo &"{$$a} x {$$b} x {$$c} = {$$product(a, b, c)}"
