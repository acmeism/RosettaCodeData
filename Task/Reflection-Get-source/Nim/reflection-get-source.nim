import macros, strformat

proc f(arg: int): int = arg+1

macro getSource(source: static[string]) =
  let module = parseStmt(source)
  for node in module.children:
    if node.kind == nnkProcDef:
      echo(&"source of procedure {node.name} is:\n{toStrLit(node).strVal}")

proc g(arg: float): float = arg*arg

getSource(staticRead(currentSourcePath()))
