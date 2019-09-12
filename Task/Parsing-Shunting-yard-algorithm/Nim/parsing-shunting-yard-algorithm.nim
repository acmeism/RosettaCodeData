import tables, strutils, sequtils, strformat

type operator = tuple[prec:int, rassoc:bool]

let ops = newTable[string, operator](
  [ ("^", (4, true )),
    ("*", (3, false)),
    ("/", (3, false)),
    ("+", (2, false)),
    ("-", (2, false)) ])

proc shuntRPN(tokens:seq[string]): string =
  var stack: seq[string]
  var op:string

  for token in tokens:
    case token
    of "(": stack.add token
    of ")":
      while stack.len > 0:
        op = stack.pop()
        if op == "(": break
        result &= op & " "
    else:
      if token in ops:
        while stack.len > 0:
          op = stack[^1]  # peek stack top
          if not (op in ops): break
          if ops[token].prec > ops[op].prec or (ops[token].rassoc and (ops[token].prec == ops[op].prec)):
            break
          discard stack.pop()
          result &= op & " "
        stack.add token
      else:
        result &= token & " "
    echo fmt"""{token:5}   {join(stack," "):18} {result:25} """

  while stack.len > 0:
    result &= stack.pop() & " "
    echo fmt"""        {join(stack," "):18} {result:25} """

let input = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"

echo &"for infix expression: '{input}' \n", "\nTOKEN   OP STACK           RPN OUTPUT"
echo "postfix: ", shuntRPN(input.strip.split)
