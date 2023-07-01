import sequtils, strutils, sugar

# List of possible variables names.
const VarChars = {'A'..'E', 'G'..'S', 'U'..'Z'}

type

  Expression = object
    names: seq[char]    # List of variables names.
    values: seq[bool]   # Associated values.
    formula: string     # Formula as a string.


proc initExpression(str: string): Expression =
  ## Build an expression from a string.
  for ch in str:
    if ch in VarChars and ch notin result.names:
      result.names.add ch
  result.values.setLen(result.names.len)
  result.formula = str


template apply(stack: seq[bool]; op: (bool, bool) -> bool): bool =
  ## Apply an operator on the last two operands of an evaluation stack.
  ## Needed to make sure that pops are done (avoiding short-circuit optimization).
  let op2 = stack.pop()
  let op1 = stack.pop()
  op(op1, op2)


proc evaluate(expr: Expression): bool =
  ## Evaluate the current expression.

  var stack: seq[bool]  # Evaluation stack.

  for e in expr.formula:
    stack.add case e
              of 'T': true
              of 'F': false
              of '!': not stack.pop()
              of '&': stack.apply(`and`)
              of '|': stack.apply(`or`)
              of '^': stack.apply(`xor`)
              else:
                if e in VarChars: expr.values[expr.names.find(e)]
                else:
                  raise newException(
                    ValueError, "Non-conformant character in expression: '$#'.".format(e))

  if stack.len != 1:
    raise newException(ValueError, "Ill-formed expression.")
  result = stack[0]


proc setVariables(expr: var Expression; pos: Natural) =
  ## Recursively set the variables.
  ## When all the variables are set, launch the evaluation of the expression
  ## and print the result.

  assert pos <= expr.values.len

  if pos == expr.values.len:
    # Evaluate and display.
    let vs = expr.values.mapIt(if it: 'T' else: 'F').join("  ")
    let es = if expr.evaluate(): 'T' else: 'F'
    echo vs, "  ", es

  else:
    # Set values.
    expr.values[pos] = false
    expr.setVariables(pos + 1)
    expr.values[pos] = true
    expr.setVariables(pos + 1)


echo "Accepts single-character variables (except for 'T' and 'F',"
echo "which specify explicit true or false values), postfix, with"
echo "&|!^ for and, or, not, xor, respectively; optionally"
echo "seperated by spaces or tabs. Just enter nothing to quit."

while true:
  # Read formula and create expression.
  stdout.write "\nBoolean expression: "
  let line = stdin.readLine.toUpperAscii.multiReplace((" ", ""), ("\t", ""))
  if line.len == 0: break
  var expr = initExpression(line)
  if expr.names.len == 0: break

  # Display the result.
  let vs = expr.names.join("  ")
  echo '\n', vs, "  ", expr.formula
  let h = vs.len + expr.formula.len + 2
  echo repeat('=', h)
  expr.setVariables(0)
