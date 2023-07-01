import strutils

type

  TokenKind* = enum
    tokMult = "Op_multiply", tokDiv = "Op_divide", tokMod = "Op_mod",
    tokAdd = "Op_add", tokSub = "Op_subtract", tokLess = "Op_less",
    tokLessEq = "Op_lessequal", tokGreater = "Op_greater",
    tokGreaterEq = "Op_greaterequal", tokEq = "Op_equal",
    tokNotEq = "Op_notequal", tokNot = "Op_not", tokAssign = "Op_assign",
    tokAnd = "Op_and", tokOr = "Op_or"
    tokLPar = "LeftParen", tokRPar = "RightParen"
    tokLBrace = "LeftBrace", tokRBrace = "RightBrace"
    tokSemi = "Semicolon", tokComma = "Comma"
    tokIf = "Keyword_if", tokElse = "Keyword_else", tokWhile = "Keyword_while",
    tokPrint = "Keyword_print", tokPutc = "Keyword_putc"
    tokIdent = "Identifier", tokInt = "Integer", tokChar = "Integer",
    tokString = "String"
    tokEnd = "End_of_input"

  Token* = object
    ln*, col*: int
    case kind*: TokenKind
    of tokIdent: ident*: string
    of tokInt: intVal*: int
    of tokChar: charVal*: char
    of tokString: stringVal*: string
    else: discard

  Lexer* = object
    input: string
    pos: int
    ln, col: int

  LexicalError* = object of CatchableError
    ln*, col*: int

proc error(lexer: var Lexer, message: string) =
  var err = newException(LexicalError, message)
  err.ln = lexer.ln
  err.col = lexer.col

template current: char =
  if lexer.pos < lexer.input.len: lexer.input[lexer.pos]
  else: '\x00'
template get(n: int): string =
  if lexer.pos < lexer.input.len:
    lexer.input[min(lexer.pos, lexer.input.len)..
                min(lexer.pos + n - 1, lexer.input.len)]
  else: ""

template next() =
  inc(lexer.pos); inc(lexer.col)
  if current() == '\n':
    inc(lexer.ln)
    lexer.col = 0
  elif current() == '\r':
    lexer.col = 0

proc skip(lexer: var Lexer) =
  while true:
    if current() in Whitespace:
      while current() in Whitespace:
        next()
      continue
    elif get(2) == "/*":
      next(); next()
      while get(2) != "*/":
        if current() == '\x00':
          lexer.error("Unterminated comment")
        next()
      next(); next()
      continue
    else: discard
    break

proc charOrEscape(lexer: var Lexer): char =
  if current() != '\\':
    result = current()
    next()
  else:
    next()
    case current()
    of 'n': result = '\n'
    of '\\': result = '\\'
    else: lexer.error("Unknown escape sequence '\\" & current() & "'")
    next()

proc next*(lexer: var Lexer): Token =
  let
    ln = lexer.ln
    col = lexer.col

  case current()
  of '*': result = Token(kind: tokMult); next()
  of '/': result = Token(kind: tokDiv); next()
  of '%': result = Token(kind: tokMod); next()
  of '+': result = Token(kind: tokAdd); next()
  of '-': result = Token(kind: tokSub); next()
  of '<':
    next()
    if current() == '=': result = Token(kind: tokLessEq)
    else: result = Token(kind: tokLess)
  of '>':
    next()
    if current() == '=':
      result = Token(kind: tokGreaterEq)
      next()
    else:
      result = Token(kind: tokGreater)
  of '=':
    next()
    if current() == '=':
      result = Token(kind: tokEq)
      next()
    else:
      result = Token(kind: tokAssign)
  of '!':
    next()
    if current() == '=':
      result = Token(kind: tokNotEq)
      next()
    else:
      result = Token(kind: tokNot)
  of '&':
    next()
    if current() == '&':
      result = Token(kind: tokAnd)
      next()
    else:
      lexer.error("'&&' expected")
  of '|':
    next()
    if current() == '|':
      result = Token(kind: tokOr)
      next()
    else:
      lexer.error("'||' expected")
  of '(': result = Token(kind: tokLPar); next()
  of ')': result = Token(kind: tokRPar); next()
  of '{': result = Token(kind: tokLBrace); next()
  of '}': result = Token(kind: tokRBrace); next()
  of ';': result = Token(kind: tokSemi); next()
  of ',': result = Token(kind: tokComma); next()
  of '\'':
    next()
    if current() == '\'': lexer.error("Empty character literal")
    let ch = lexer.charOrEscape()
    if current() != '\'':
      lexer.error("Character literal must contain a single character or " &
                  "escape sequence")
    result = Token(kind: tokChar, charVal: ch)
    next()
  of '0'..'9':
    var number = ""
    while current() in Digits:
      number.add(current())
      next()
    if current() in IdentStartChars:
      lexer.error("Integer literal ends in non-digit characters")
    result = Token(kind: tokInt, intVal: parseInt(number))
  of '"':
    next()
    var str = ""
    while current() notin {'"', '\x00', '\n'}:
      str.add(lexer.charOrEscape())
    if current() == '\x00':
      lexer.error("Unterminated string literal")
    elif current() == '\n':
      lexer.error("Line feed in string literal")
    else:
      next()
      result = Token(kind: tokString, stringVal: str)
  of IdentStartChars:
    var ident = $current()
    next()
    while current() in IdentChars:
      ident.add(current())
      next()
    case ident
    of "if": result = Token(kind: tokIf)
    of "else": result = Token(kind: tokElse)
    of "while": result = Token(kind: tokWhile)
    of "print": result = Token(kind: tokPrint)
    of "putc": result = Token(kind: tokPutc)
    else: result = Token(kind: tokIdent, ident: ident)
  of '\x00':
    result = Token(kind: tokEnd)
  else:
    lexer.error("Unexpected character: '" & current() & "'")

  result.ln = ln
  result.col = col
  lexer.skip()

proc peek*(lexer: var Lexer): Token =
  discard

proc initLexer*(input: string): Lexer =
  result = Lexer(input: input, pos: 0, ln: 1, col: 1)
  result.skip()

when isMainModule:
  let code = readAll(stdin)
  var
    lexer = initLexer(code)
    token: Token
  while true:
    token = lexer.next()
    stdout.write(token.ln, ' ', token.col, ' ', token.kind)
    case token.kind
    of tokInt: stdout.write(' ', token.intVal)
    of tokChar: stdout.write(' ', token.charVal.ord)
    of tokString: stdout.write(" \"", token.stringVal
                    .replace("\\", "\\\\")
                    .replace("\n", "\\n"), '"')
    of tokIdent: stdout.write(' ', token.ident)
    else: discard
    stdout.write('\n')
    if token.kind == tokEnd:
      break
