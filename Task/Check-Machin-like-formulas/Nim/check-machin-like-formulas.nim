import bignum

type

  # Description of a term.
  Term = object
    factor: int    # Multiplier (may be negative).
    fract: Rat     # Argument of arc tangent.

  Expression = seq[Term]

# Rational 1.
let One = newRat(1)


####################################################################################################
# Formula parser.

type

  # Possible tokens for parsing.
  Token = enum tkPi, tkArctan, tkNumber, tkEqual, tkAdd, tkSub,
               tkMul, tkDiv, tkLPar, tkRPar, tkError, tkEnd

  # Lexer description.
  Lexer = object
    line: string      # The line to parse.
    pos: Natural      # Current position of lexer.
    token: Token      # Current token.
    value: Natural    # Associated value (for numbers).

  # Exception raised if an error is found.
  SyntaxError = object of CatchableError

#---------------------------------------------------------------------------------------------------

proc initLexer(line: string): Lexer =
  ## Create and initialize a lexer.
  result.line = line
  result.pos = 0

#---------------------------------------------------------------------------------------------------

proc parseName(lexer: var Lexer; pos: Natural) =
  ## Parse a name.

  # Build the name.
  var pos = pos
  var name = ""
  while pos < lexer.line.len and (let c = lexer.line[pos]; c) in 'a'..'z':
    name.add(c)
    inc pos

  # Update lexer state.
  lexer.token = if name == "arctan": tkArctan
                elif name == "pi": tkPi
                else: tkError
  lexer.pos = pos

#---------------------------------------------------------------------------------------------------

proc parseNumber(lexer: var Lexer; pos: Natural) =
  ## Parse a number.

  # Build the number.
  var pos = pos
  var value = 0
  while pos < lexer.line.len and (let c = lexer.line[pos]; c) in '0'..'9':
    value = 10 * value + ord(c) - ord('0')
    inc pos

  # Update lexer state.
  lexer.token = tkNumber
  lexer.value = value
  lexer.pos = pos

#---------------------------------------------------------------------------------------------------

proc getNextToken(lexer: var Lexer) =
  ## Find next token.

  var pos = lexer.pos
  var token: Token
  while pos < lexer.line.len and lexer.line[pos] == ' ': inc pos
  if pos == lexer.line.len:
    # Reached end of string.
    lexer.pos = pos
    lexer.token = tkEnd
    return

  # Find token.
  case lexer.line[pos]
  of '=': token = tkEqual
  of '+': token = tkAdd
  of '-': token = tkSub
  of '*': token = tkMul
  of '/': token = tkDiv
  of '(': token = tkLPar
  of ')': token = tkRPar
  of 'a'..'z':
    lexer.parseName(pos)
    return
  of '0'..'9':
    lexer.parseNumber(pos)
    return
  else: token = tkError

  # Update lexer state.
  lexer.pos = pos + 1
  lexer.token = token

#---------------------------------------------------------------------------------------------------

template syntaxError(message: string) =
  ## Raise a syntax error exception.
  raise newException(SyntaxError, message)

#---------------------------------------------------------------------------------------------------

proc parseFraction(lexer: var Lexer): Rat =
  ## Parse a fraction: number / number.

  lexer.getNextToken()
  if lexer.token != tkNumber:
    syntaxError("number expected.")
  let num = lexer.value
  lexer.getNextToken()
  if lexer.token != tkDiv:
    syntaxError("“/” expected.")
  lexer.getNextToken()
  if lexer.token != tkNumber:
    syntaxError("number expected")
  if lexer.value == 0:
    raise newException(ValueError, "null denominator.")
  let den = lexer.value
  result = newRat(num, den)

#---------------------------------------------------------------------------------------------------

proc parseTerm(lexer: var Lexer): Term =
  ## Parse a term: factor * arctan(fraction) or arctan(fraction).

  lexer.getNextToken()

  # Parse factor.
  if lexer.token == tkNumber:
    result.factor = lexer.value
    lexer.getNextToken
    if lexer.token != tkMul:
      syntaxError("“*” expected.")
    lexer.getNextToken()
  else:
    result.factor = 1

  # Parse arctan.
  if lexer.token != tkArctan:
    syntaxError("“arctan” expected.")
  lexer.getNextToken()
  if lexer.token != tkLPar:
    syntaxError("“(” expected.")
  result.fract = lexer.parseFraction()
  lexer.getNextToken()
  if lexer.token != tkRPar:
    syntaxError("“)” expected.")

#---------------------------------------------------------------------------------------------------

proc parse(line: string): Expression =
  ## Parse a formula.

  var lexer = initLexer(line)
  lexer.getNextToken()

  if lexer.token != tkPi:
    syntaxError("pi symbol expected.")
  lexer.getNextToken()

  if lexer.token != tkDiv:
    syntaxError("'/' expected.")
  lexer.getNextToken()

  if lexer.token != tkNumber:
    syntaxError("number expected.")
  if lexer.value != 4:
    raise newException(ValueError, "value 4 expected.")
  lexer.getNextToken()

  if lexer.token != tkEqual:
    syntaxError("“=” expected.")
  result.add(lexer.parseTerm())
  lexer.getNextToken()

  # Parse the next terms.
  while (let token = lexer.token; token) in {tkAdd, tkSub}:
    var term = lexer.parseTerm()
    if token == tkSub:
      term.factor = -term.factor
    result.add(term)
    lexer.getNextToken()

  if lexer.token != tkEnd:
    syntaxError("invalid characters at end of formula.")


####################################################################################################
# Evaluator.

proc tangent(factor: int; fract: Rat): Rat =
  ## Compute the tangent of "factor * arctan(fract)".

  if factor == 1:
    return fract
  if factor < 0:
    return -tangent(-factor, fract)

  # Split in two parts.
  let n = factor div 2
  let a = tangent(n, fract)
  let b = tangent(factor - n, fract)
  result = (a + b) / (One - a * b)

#---------------------------------------------------------------------------------------------------

proc tangent(expr: Expression): Rat =
  ## Compute the tangent of a sum of terms.

  if expr.len == 1:
    result = tangent(expr[0].factor, expr[0].fract)
  else:
    # Split in two parts.
    let a = tangent(expr[0..<(expr.len div 2)])
    let b = tangent(expr[(expr.len div 2)..^1])
    result = (a + b) / (One - a * b)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  const Formulas = [
    "pi/4 = arctan(1/2) + arctan(1/3)",
    "pi/4 = 2*arctan(1/3) + arctan(1/7)",
    "pi/4 = 4*arctan(1/5) - arctan(1/239)",
    "pi/4 = 5*arctan(1/7) + 2*arctan(3/79)",
    "pi/4 = 5*arctan(29/278) + 7*arctan(3/79)",
    "pi/4 = arctan(1/2) + arctan(1/5) + arctan(1/8)",
    "pi/4 = 4*arctan(1/5) - arctan(1/70) + arctan(1/99)",
    "pi/4 = 5*arctan(1/7) + 4*arctan(1/53) + 2*arctan(1/4443)",
    "pi/4 = 6*arctan(1/8) + 2*arctan(1/57) + arctan(1/239)",
    "pi/4 = 8*arctan(1/10) - arctan(1/239) - 4*arctan(1/515)",
    "pi/4 = 12*arctan(1/18) + 8*arctan(1/57) - 5*arctan(1/239)",
    "pi/4 = 16*arctan(1/21) + 3*arctan(1/239) + 4*arctan(3/1042)",
    "pi/4 = 22*arctan(1/28) + 2*arctan(1/443) - 5*arctan(1/1393) - 10*arctan(1/11018)",
    "pi/4 = 22*arctan(1/38) + 17*arctan(7/601) + 10*arctan(7/8149)",
    "pi/4 = 44*arctan(1/57) + 7*arctan(1/239) - 12*arctan(1/682) + 24*arctan(1/12943)",
    "pi/4 = 88*arctan(1/172) + 51*arctan(1/239) + 32*arctan(1/682) + 44*arctan(1/5357) + 68*arctan(1/12943)",
    "pi/4 = 88*arctan(1/172) + 51*arctan(1/239) + 32*arctan(1/682) + 44*arctan(1/5357) + 68*arctan(1/12944)"]

for formula in Formulas:
  let expr = formula.parse()
  let value = tangent(expr)
  if value == 1:
    echo "True:  ", formula
  else:
    echo "False: ", formula
    echo "Tangent of the right expression is about ", value.toFloat
