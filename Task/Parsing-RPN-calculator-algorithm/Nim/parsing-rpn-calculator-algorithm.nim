import math, rdstdin, strutils, tables

type Stack = seq[float]

proc opPow(s: var Stack) =
  let b = s.pop
  let a = s.pop
  s.add a.pow b

proc opMul(s: var Stack) =
  let b = s.pop
  let a = s.pop
  s.add a * b

proc opDiv(s: var Stack) =
  let b = s.pop
  let a = s.pop
  s.add a / b

proc opAdd(s: var Stack) =
  let b = s.pop
  let a = s.pop
  s.add a + b

proc opSub(s: var Stack) =
  let b = s.pop
  let a = s.pop
  s.add a - b

proc opNum(s: var Stack; num: float) =
  s.add num

let ops = toTable({"^": opPow,
                   "*": opMul,
                   "/": opDiv,
                   "+": opAdd,
                   "-": opSub})

proc getInput(inp = ""): seq[string] =
  var inp = inp
  if inp.len == 0:
    inp = readLineFromStdin "Expression: "
  result = inp.strip.split

proc rpnCalc(tokens: seq[string]): seq[seq[string]] =
  var s: Stack
  result = @[@["TOKEN","ACTION","STACK"]]
  for token in tokens:
    var action = ""
    if ops.hasKey token:
      action = "Apply op to top of stack"
      ops[token](s)
    else:
      action = "Push num onto top of stack"
      s.opNum token.parseFloat
    result.add(@[token, action, s.join(" ")])

let rpn = "3 4 2 * 1 5 - 2 3 ^ ^ / +"
echo "For RPN expression: ", rpn
let rp = rpnCalc rpn.getInput

var maxColWidths = newSeq[int](rp[0].len)
for i in 0 .. rp[0].high:
  for x in rp:
    maxColWidths[i] = max(maxColWidths[i], x[i].len + 3)

for x in rp:
  for i, y in x:
    stdout.write y.alignLeft(maxColWidths[i])
  echo ""
