proc parse(s: string): seq[string] =
  var tmp = ""
  for ch in s:
    case ch
    of ' ':
      if tmp != "": result.add tmp
      tmp = ""
      continue
    of '+', '*', '(', ')':
      if tmp != "": result.add tmp
      tmp = ""
      result.add $ch
    else:
      tmp &= ch
  if tmp != "": result.add tmp

proc shuntRPN(s: string): seq[string] =
  let ops = "+*"
  var tokens = parse s
  var stack: seq[string]
  var op: string

  for token in tokens:
    case token
    of "(":
      stack.add token
    of ")":
      while stack.len > 0:
        op = stack.pop()
        if op == "(": break
        result.add op
    else:
      if token in ops:
        while stack.len > 0:
          op = stack[^1]
          if op notin ops: break
          if ops.find(token) >= ops.find(op): break
          discard stack.pop()
          result.add op
        stack.add token
      else: result.add token

  while stack.len > 0: result.add stack.pop()

proc infix(voltage:float, s:string): Node = calculate(voltage, shuntRPN s)
node = infix(18, "((((10+2)*6+8)*6+4)*8+4)*8+6")
assert 10 == node.res
assert 18 == node.voltage
assert 1.8 == node.current()
assert 32.4 == node.effect()
assert '+' == node.kind
