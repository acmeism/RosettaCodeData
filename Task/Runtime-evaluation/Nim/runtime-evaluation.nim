import ../compiler/[nimeval, llstream, ast], strformat, os

let std = findNimStdLibCompileTime()
let modules = [std, std / "pure", std / "std", std / "core"]
var intr = createInterpreter("script", modules)

#dynamic variable
let varname = commandLineParams()[0]
let expr = commandLineParams()[1]

#wrap the naked variable name and expression in a definition and proc,respectively to create valid code
#for simplicity, the variable will always be an int, but one could of course define the type at runtime
#globals and procs must be exported with * to be accessable
#we also need to import any modules needed by the runtime code
intr.evalScript(llStreamOpen(&"import math,sugar; var {varname}*:int; proc output*():auto = {expr}"))

for i in 0..2:
  #set 'varname' to a value
  intr.getGlobalValue(intr.selectUniqueSymbol(varname)).intval = i
  #evaluate the expression and get the result
  let output = intr.callRoutine(intr.selectRoutine("output"), [])
  #depending on the expression, the result could be any type
  #as an example, here we check for int,float,or string
  case output.kind
  of nkIntLit:
    echo expr, " = ", output.intval
  of nkFloatLit:
    echo expr, " = ", output.floatval
  of nkStrLit:
    echo expr, " = ", output.strval
  else:
    discard

destroyInterpreter(intr)
