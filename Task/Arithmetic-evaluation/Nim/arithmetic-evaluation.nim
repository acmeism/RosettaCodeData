import strutils
import os

#--
# Lexer
#--

type
  TokenKind = enum
    tokNumber
    tokPlus = "+", tokMinus = "-", tokStar = "*", tokSlash = "/"
    tokLPar, tokRPar
    tokEnd
  Token = object
    case kind: TokenKind
    of tokNumber: value: float
    else: discard

proc lex(input: string): seq[Token] =
  # Here we go through the entire input string and collect all the tokens into
  # a sequence.
  var pos = 0
  while pos < input.len:
    case input[pos]
    of '0'..'9':
      # Digits consist of three parts: the integer part, the delimiting decimal
      # point, and the decimal part.
      var numStr = ""
      while pos < input.len and input[pos] in Digits:
        numStr.add(input[pos])
        inc(pos)
      if pos < input.len and input[pos] == '.':
        numStr.add('.')
        inc(pos)
        while pos < input.len and input[pos] in Digits:
          numStr.add(input[pos])
          inc(pos)
      result.add(Token(kind: tokNumber, value: numStr.parseFloat()))
    of '+': inc(pos); result.add(Token(kind: tokPlus))
    of '-': inc(pos); result.add(Token(kind: tokMinus))
    of '*': inc(pos); result.add(Token(kind: tokStar))
    of '/': inc(pos); result.add(Token(kind: tokSlash))
    of '(': inc(pos); result.add(Token(kind: tokLPar))
    of ')': inc(pos); result.add(Token(kind: tokRPar))
    of ' ': inc(pos)
    else: raise newException(ArithmeticError,
                             "Unexpected character '" & input[pos] & '\'')
  # We append an 'end' token to the end of our token sequence, to mark where the
  # sequence ends.
  result.add(Token(kind: tokEnd))

#--
# Parser
#--

type
  ExprKind = enum
    exprNumber
    exprBinary
  Expr = ref object
    case kind: ExprKind
    of exprNumber: value: float
    of exprBinary:
      left, right: Expr
      operator: TokenKind

proc `$`(ex: Expr): string =
  # This proc returns a lisp representation of the expression.
  case ex.kind
  of exprNumber: $ex.value
  of exprBinary: '(' & $ex.operator & ' ' & $ex.left & ' ' & $ex.right & ')'

var
  # The input to the program is provided via command line parameters.
  tokens = lex(commandLineParams().join(" "))
  pos = 0

# This table stores the precedence level of each infix operator. For tokens
# this does not apply to, the precedence is set to 0.
const Precedence: array[low(TokenKind)..high(TokenKind), int] = [
  tokNumber: 0,
  tokPlus: 1,
  tokMinus: 1,
  tokStar: 2,
  tokSlash: 2,
  tokLPar: 0,
  tokRPar: 0,
  tokEnd: 0
]

# We use a Pratt parser, so the two primary components are the prefix part, and
# the infix part. We start with a prefix token, and when we're done, we continue
# with an infix token.

proc parse(prec = 0): Expr

proc parseNumber(token: Token): Expr =
  result = Expr(kind: exprNumber, value: token.value)

proc parseParen(token: Token): Expr =
  result = parse()
  if tokens[pos].kind != tokRPar:
    raise newException(ArithmeticError, "Unbalanced parenthesis")
  inc(pos)

proc parseBinary(left: Expr, token: Token): Expr =
  result = Expr(kind: exprBinary, left: left, right: parse(),
                operator: token.kind)

proc parsePrefix(token: Token): Expr =
  case token.kind
  of tokNumber: result = parseNumber(token)
  of tokLPar: result = parseParen(token)
  else: discard

proc parseInfix(left: Expr, token: Token): Expr =
  case token.kind
  of tokPlus, tokMinus, tokStar, tokSlash: result = parseBinary(left, token)
  else: discard

proc parse(prec = 0): Expr =
  # This procedure is the heart of a Pratt parser, it puts the whole expression
  # together into one abstract syntax tree, properly dealing with precedence.
  var token = tokens[pos]
  inc(pos)
  result = parsePrefix(token)
  while prec < Precedence[tokens[pos].kind]:
    token = tokens[pos]
    if token.kind == tokEnd:
      # When we hit the end token, we're done.
      break
    inc(pos)
    result = parseInfix(result, token)

let ast = parse()

proc `==`(ex: Expr): float =
  # This proc recursively evaluates the given expression.
  result =
    case ex.kind
    of exprNumber: ex.value
    of exprBinary:
      case ex.operator
      of tokPlus: ==ex.left + ==ex.right
      of tokMinus: ==ex.left - ==ex.right
      of tokStar: ==ex.left * ==ex.right
      of tokSlash: ==ex.left / ==ex.right
      else: 0.0

# In the end, we print out the result.
echo ==ast
