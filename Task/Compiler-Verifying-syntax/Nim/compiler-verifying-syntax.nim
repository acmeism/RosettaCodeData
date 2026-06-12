import strutils, tables

type

  # List of tokens with their textual representation.
  Token = enum tkError = "invalid token", tkIdent = "identifier", tkInt = "integer",
               tkLPar = "'('", tkRPar = "')'", tkFalse = "'false'", tkTrue = "'true'",
               tkLt = "'<'", tkEq = "'='", tkAdd = "'+'", tkSub = "'-'", tkMul = "'*'",
               tkDiv = "'/'", tkOr = "'or'", tkAnd = "'and'", tkNot = "'not'", tkEOF = "EOF"

  Lexer = object
    str: string     # String to parse.
    len: Natural    # String length.
    pos: int        # Current lexer position.
    token: Token    # Current token.
    error: string   # Error message.

const

  # Mapping of reserved identifiers to tokens.
  IdentTokens = {"false": tkFalse, "true": tkTrue, "or": tkOr, "and": tkAnd, "not": tkNot}.toTable

  # Mapping of characters to tokens.
  CharTokens = {'(': tkLPar, ')': tkRPar, '<': tkLt, '=': tkEq,
                '+': tkAdd, '-': tkSub, '*': tkMul, '/': tkDiv}.toTable


####################################################################################################
# Lexer.

# Forward reference.
func nextToken(lex: var Lexer)


func initLexer(str: string): Lexer =
  ## Initialize a lexer.
  result = Lexer(str: str, len: str.len, pos: 0)
  result.nextToken()  # Always a token ahead.


func getIdToken(lex: var Lexer) =
  ## Get the token for an identifier.
  var str: string
  while lex.pos < lex.len and lex.str[lex.pos] in IdentChars:
    str.add lex.str[lex.pos]
    inc lex.pos
  lex.token = IdentTokens.getOrDefault(str, tkIdent)


func getInt(lex: var Lexer) =
  ## Get an integer token.
  while lex.pos < lex.len and lex.str[lex.pos] in Digits:
    inc lex.pos
  lex.token = tkInt


func nextToken(lex: var Lexer) =
  ## Find the next token.

  # Skip spaces.
  while lex.pos < lex.str.len and lex.str[lex.pos] == ' ':
    inc lex.pos

  if lex.pos == lex.str.len:
    lex.token = tkEOF

  else:
    let ch = lex.str[lex.pos]
    case ch
    of 'a'..'z':
      lex.getIdToken()
    of '0'..'9':
      lex.getint()
    else:
      inc lex.pos
      lex.token = CharTokens.getOrDefault(ch, tkError)


####################################################################################################
# Parser.

# Forward reference.
proc checkExpr(lex: var Lexer): bool


proc checkPrimary(lex: var Lexer): bool =
  ## Check validity of a primary.

  if lex.token in {tkIdent, tkInt, tkFalse, tkTrue}:
    lex.nextToken()
    return true

  elif lex.token == tkLPar:
    lex.nextToken()
    if not lex.checkExpr():
      return false
    if lex.token != tkRPar:
      lex.error = "Encountered $#; expected ')'.".format(lex.token)
      return false
    else:
      lex.nextToken()
      return true

  else:
    lex.error = "Encountered $#; expected identifier, litteral or '('.".format(lex.token)
    return false


proc checkExpr6(lex: var Lexer): bool =
  ## Check validity of an expr6.

  if not lex.checkPrimary(): return false
  while lex.token in [tkMul, tkDiv]:
    lex.nextToken()
    if not lex.checkPrimary(): return false
  result = true


proc checkExpr5(lex: var Lexer): bool =
  ## Check validity of an expr5.

  if not lex.checkExpr6(): return false
  while lex.token in [tkAdd, tkSub]:
    lex.nextToken()
    if not lex.checkExpr6(): return false
  result = true


proc checkExpr4(lex: var Lexer): bool =
  ## Check validity of an expr4.

  if lex.token == tkNot: lex.nextToken()
  if not lex.checkExpr5(): return false
  if lex.token in [tkLt, tkEq]:
    lex.nextToken()
    if not lex.checkExpr5(): return false
  result = true


proc checkExpr3(lex: var Lexer): bool =
  ## Check validity of an expr3.

  if not lex.checkExpr4(): return false
  while lex.token == tkAnd:
    lex.nextToken()
    if not lex.checkExpr4(): return false
  result = true


proc checkExpr2(lex: var Lexer): bool =
  ## Check validity of an expr2.

  if not lex.checkExpr3(): return false
  while lex.token == tkOr:
    lex.nextToken()
    if not lex.checkExpr3(): return false
  result = true


proc checkExpr(lex: var Lexer): bool =
  ## Check validity of an expr.
  lex.checkExpr2()


proc checkStmt(lex: var Lexer): bool =
  ## Check validity of a statement.

  result = lex.checkExpr()
  if result and lex.pos < lex.len:
    lex.error = "Extra characters at end of statement."
    result = false

#———————————————————————————————————————————————————————————————————————————————————————————————————

# Using test set from Algol68 version.

const Tests = ["wombat",
               "wombat or monotreme",
               "( wombat and not )",
               "wombat or not",
               "a + 1",
               "a + b < c",
               "a + b - c * d / e < f and not ( g = h )",
               "a + b - c * d / e < f and not ( g = h",
               "a = b",
               "a or b = c",
               "$",
               "true or false = not true",
               "not true = false",
               "3 + not 5",
               "3 + (not 5)",
               "(42 + 3",
               " not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true",
               " and 3 < 2",
               "not 7 < 2",
               "2 < 3 < 4",
               "2 < foobar - 3 < 4",
               "2 < foobar and 3 < 4",
               "4 * (32 - 16) + 9 = 73",
               "235 76 + 1",
               "a + b = not c and false",
               "a + b = (not c) and false",
               "a + b = (not c and false)",
               "ab_c / bd2 or < e_f7",
               "g not = h",
               "été = false",
               "i++",
               "j & k",
               "l or _m"]

for test in Tests:
  var lex = initLexer(test)
  let ok = checkStmt(lex)
  echo test, " → ", ok
  if not ok: echo "*** Error at position $1. $2 ".format(lex.pos, lex.error)
