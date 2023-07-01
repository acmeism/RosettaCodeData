import tables

var
  theVar: int = 5
  varMap = initTable[string, pointer]()

proc ptrToInt(p: pointer): int =
  result = cast[ptr int](p)[]

proc main() =
  write(stdout, "Enter a var name: ")
  let sVar = readLine(stdin)
  varMap[$svar] = theVar.addr
  echo "Variable ", sVar, " is ", ptrToInt(varMap[$sVar])

when isMainModule:
  main()
