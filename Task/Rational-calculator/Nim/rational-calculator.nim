import std/[strutils, strformat, streams, rdstdin, rationals, tables]

#[
Grammar:

Expr    -> Sum
Sum     -> Product (('+'|'-') Product)*
Product -> Unary (('*'|'/') Unary)*
Unary   -> ('-'|'+'|'abs')? Atom
Atom    -> Prev | Number | '(' Expr ')'
]#

type
  SyntaxError = object of CatchableError
  Fraction = Rational[int]

  TokenKind = enum
    Prev, Number, LParen, RParen,
    Plus, Minus, Star, Slash, AbsVal,
    Null

  Token = object
    kind*: TokenKind
    text*: string

  TokenStream = object
    contents*: seq[Token]
    head*: int = 0

  Calculator = object
    expr*: TokenStream
    answer*: Fraction = 0 // 1

const
  specialChars = {'+', '-', '*', '/', '@', ' ', '(', ')'}
  # valid characters = Digits + Letters + specialChars

  IllegalTokenSequences = [
    [TokenKind.Number, TokenKind.LParen],
    [TokenKind.Prev, TokenKind.LParen],
    [TokenKind.RParen, TokenKind.Number],
    [TokenKind.RParen, TokenKind.Prev],
    [TokenKind.Number, TokenKind.Number],
    [TokenKind.Number, TokenKind.Prev],
    [TokenKind.Prev, TokenKind.Number],
    [TokenKind.Prev, TokenKind.Prev],
  ]

let
  unaryOps = {
    TokenKind.Plus: proc(x: Fraction): Fraction = x,
    TokenKind.AbsVal: proc(x: Fraction): Fraction = abs(x),
    TokenKind.Minus: proc(x: Fraction): Fraction = abs(x) * (-1 // 1)
  }.toTable

  binaryOps = {
    TokenKind.Plus: proc(x, y: Fraction): Fraction = (x + y),
    TokenKind.Minus: proc(x, y: Fraction): Fraction = (x - y),
    TokenKind.Star: proc(x, y: Fraction): Fraction = (x * y),
    TokenKind.Slash: proc(x, y: Fraction): Fraction = (x / y),
  }.toTable

  tokenTable = {
    '+': TokenKind.Plus, '-': TokenKind.Minus,
    '*': TokenKind.Star, '/': TokenKind.Slash,
    '(': TokenKind.LParen, ')': TokenKind.RParen,
    '@': TokenKind.Prev
  }.toTable

proc isAtEnd(ts: var TokenStream): bool =
  return ts.head >= ts.contents.len

proc peek(ts: var TokenStream): Token =
  if ts.isAtEnd:
    return Token(kind: TokenKind.Null, text: "\0")
  return ts.contents[ts.head]

proc read(ts: var TokenStream): Token =
  result = ts.peek
  if not ts.isAtEnd: ts.head.inc

proc previousToken(ts: var TokenStream): Token =
  if ts.head > 0:
    return ts.contents[ts.head - 1]
  else:
    return Token(kind: TokenKind.Null, text: "\0")

proc matchAhead(ts: var TokenStream, target: TokenKind): bool =
  if ts.peek.kind != target:
    return false
  else:
    return true

proc expectAhead(ts: var TokenStream, target: TokenKind): bool =
  if ts.read.kind != target:
    return false
  else:
    return true

proc evalExpr(calc: var Calculator): Fraction
# This forward declaration is necessary to implement recursive descent.

proc evalAtom(calc: var Calculator): Fraction =
  if calc.expr.matchAhead(TokenKind.Prev):
    discard calc.expr.read
    return calc.answer
  elif calc.expr.matchAhead(TokenKind.Number):
    try:
      return parseInt(calc.expr.read.text) // 1
    except:
      raise newException(OverflowDefect,
        &"The integer '{calc.expr.previousToken.text}' is too large to compute.")
  elif calc.expr.matchAhead(TokenKind.LParen):
    discard calc.expr.read
    try:
      result = calc.evalExpr()
    except:
      raise newException(ValueError, getCurrentExceptionMsg())
    if not calc.expr.expectAhead(TokenKind.RParen):
      raise newException(SyntaxError, "Expression requires a closing parenthesis.")
  else:
    raise newException(SyntaxError, "Could not parse expression.")

proc evalUnary(calc: var Calculator): Fraction =
  if calc.expr.peek.kind in unaryOps:
    try:
      return unaryOps[calc.expr.read.kind](calc.evalAtom())
    except:
      raise newException(ValueError,
        "A unary operation must be followed by an atomic expression. [Ex: +(abs (-9))]")
  else:
    return calc.evalAtom()

proc evalProduct(calc: var Calculator): Fraction =
  result = calc.evalUnary()
  while calc.expr.peek.kind in {TokenKind.Star, TokenKind.Slash}:
    try:
      result = binaryOps[calc.expr.read.kind](result, calc.evalUnary())
    except:
      raise newException(ValueError, "Could not construct product.")

proc evalSum(calc: var Calculator): Fraction =
  result = calc.evalProduct()
  while calc.expr.peek.kind in {TokenKind.Plus, TokenKind.Minus}:
    try:
      result = binaryOps[calc.expr.read.kind](result, calc.evalProduct())
    except:
      raise newException(ValueError, "Could not construct sum.")

proc evalExpr(calc: var Calculator): Fraction =
  result = calc.evalSum()

proc getTokenStream(input: string): TokenStream =
  let stream = newStringStream(input)
  defer: stream.close()
  while not stream.atEnd:
    var current = stream.readChar()
    case current
    of Digits:
      result.contents.add Token(kind: TokenKind.Number, text: $current)
      while stream.peekChar() in Digits:
        result.contents[^1].text &= stream.readChar()
    of Letters:
      var text = $current
      while stream.peekChar() in Letters:
        text &= stream.readChar()
      if text == "abs":
        result.contents.add Token(kind: TokenKind.AbsVal, text: text)
      else:
        raise newException(SyntaxError, &"'{text}' is not a valid operator.")
    of specialChars:
      if current == ' ':
        discard
      else:
        result.contents.add Token(kind: tokenTable[current], text: $current)
    else:
      raise newException(SyntaxError, &"'{$current}' is an INVALID character.")
    for i in 0..<(result.contents.len - 1):
      if [result.contents[i].kind, result.contents[i+1].kind] in IllegalTokenSequences:
        raise newException(SyntaxError, "Atomic expressions must be separated by operators.")

proc printFraction(frac: Fraction): string =
  if frac.den == 1:
    return $frac.num
  else:
    return $frac.toFloat()

proc repl() =
  echo """
    Enter '@' to insert value of previous expression.
    Enter an empty line, Ctrl-C, or Ctrl-D to exit program.
  """.dedent
  var
    line: string
    calc = Calculator()

  while true:
    let inputExists = readLineFromStdin("> ", line)
    if not inputExists or line == "":
      break
    else:
      try:
        calc.expr = line.getTokenStream
        calc.answer = calc.evalExpr()
        if not calc.expr.isAtEnd:
          raise newException(SyntaxError, &"Expression improperly terminated at '{calc.expr.peek.text}'.")
        else:
          echo &"\n  = {calc.answer}\n  = {calc.answer.printFraction()}\n"
      except:
        echo getCurrentExceptionMsg()

when isMainModule:
  repl()
