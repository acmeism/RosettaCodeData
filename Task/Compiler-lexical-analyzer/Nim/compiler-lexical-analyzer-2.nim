import lexbase, streams
from strutils import Whitespace

type
  TokenKind = enum
    tkInvalid = "Invalid",
    tkOpMultiply = "Op_multiply",
    tkOpDivide = "Op_divide",
    tkOpMod = "Op_mod",
    tkOpAdd = "Op_add",
    tkOpSubtract = "Op_subtract",
    tkOpLess = "Op_less",
    tkOpLessEqual = "Op_lessequal",
    tkOpGreater = "Op_greater",
    tkOpGreaterEqual = "Op_greaterequal",
    tkOpEqual = "Op_equal",
    tkOpNotEqual = "Op_notequal",
    tkOpNot = "Op_not",
    tkOpAssign = "Op_assign",
    tkOpAnd = "Op_and",
    tkOpOr = "Op_or",
    tkLeftParen = "LeftParen",
    tkRightParen = "RightParen",
    tkLeftBrace = "LeftBrace",
    tkRightBrace = "RightBrace",
    tkSemicolon = "Semicolon",
    tkComma = "Comma",
    tkKeywordIf = "Keyword_if",
    tkKeywordElse = "Keyword_else",
    tkKeywordWhile = "Keyword_while",
    tkKeywordPrint = "Keyword_print",
    tkKeywordPutc = "Keyword_putc",
    tkIdentifier = "Identifier",
    tkInteger = "Integer",
    tkString = "String",
    tkEndOfInput = "End_of_input"

  Lexer = object of BaseLexer
    kind: TokenKind
    token, error: string
    startPos: int

template setError(l: var Lexer; err: string): untyped =
  l.kind = tkInvalid
  if l.error.len == 0:
    l.error = err

proc hasError(l: Lexer): bool {.inline.} =
  l.error.len > 0

proc open(l: var Lexer; input: Stream) {.inline.} =
  lexbase.open(l, input)
  l.startPos = 0
  l.kind = tkInvalid
  l.token = ""
  l.error = ""

proc handleNewLine(l: var Lexer) =
  case l.buf[l.bufpos]
  of '\c': l.bufpos = l.handleCR l.bufpos
  of '\n': l.bufpos = l.handleLF l.bufpos
  else: discard

proc skip(l: var Lexer) =
  while true:
    case l.buf[l.bufpos]
    of Whitespace:
      if l.buf[l.bufpos] notin NewLines:
        inc l.bufpos
      else:
        handleNewLine l
    of '/':
      if l.buf[l.bufpos + 1] == '*':
        inc l.bufpos, 2
        while true:
          case l.buf[l.bufpos]
          of '*':
            if l.buf[l.bufpos + 1] == '/':
              inc l.bufpos, 2
              break
            else: inc l.bufpos
          of NewLines:
            handleNewLine l
          of EndOfFile:
            setError l, "EOF reached in comment"
            return
          else:
            inc l.bufpos
      else: break
    else: break

proc handleSpecial(l: var Lexer): char =
  assert l.buf[l.bufpos] == '\\'
  inc l.bufpos
  case l.buf[l.bufpos]
  of 'n':
    l.token.add "\\n"
    result = '\n'
    inc l.bufpos
  of '\\':
    l.token.add "\\\\"
    result = '\\'
    inc l.bufpos
  else:
    setError l, "Unknown escape sequence: '\\" & l.buf[l.bufpos] & "'"
    result = '\0'

proc handleChar(l: var Lexer) =
  assert l.buf[l.bufpos] == '\''
  l.startPos = l.getColNumber l.bufpos
  l.kind = tkInvalid
  inc l.bufpos
  if l.buf[l.bufpos] == '\\':
    l.token = $ord(handleSpecial l)
    if hasError l: return
  elif l.buf[l.bufpos] == '\'':
    setError l, "Empty character constant"
    return
  else:
    l.token = $ord(l.buf[l.bufpos])
    inc l.bufpos
  if l.buf[l.bufpos] == '\'':
    l.kind = tkInteger
    inc l.bufpos
  else:
    setError l, "Multi-character constant"

proc handleString(l: var Lexer) =
  assert l.buf[l.bufpos] == '"'
  l.startPos = l.getColNumber l.bufpos
  l.token = "\""
  inc l.bufpos
  while true:
    case l.buf[l.bufpos]
    of '\\':
      discard handleSpecial l
      if hasError l: return
    of '"':
      l.kind = tkString
      add l.token, '"'
      inc l.bufpos
      break
    of NewLines:
      setError l, "EOL reached before end-of-string"
      return
    of EndOfFile:
      setError l, "EOF reached before end-of-string"
      return
    else:
      add l.token, l.buf[l.bufpos]
      inc l.bufpos

proc handleNumber(l: var Lexer) =
  assert l.buf[l.bufpos] in {'0'..'9'}
  l.startPos = l.getColNumber l.bufpos
  l.token = "0"
  while l.buf[l.bufpos] == '0': inc l.bufpos
  while true:
    case l.buf[l.bufpos]
    of '0'..'9':
      if l.token == "0":
        setLen l.token, 0
      add l.token, l.buf[l.bufpos]
      inc l.bufpos
    of 'a'..'z', 'A'..'Z', '_':
      setError l, "Invalid number"
      return
    else:
      l.kind = tkInteger
      break

proc handleIdent(l: var Lexer) =
  assert l.buf[l.bufpos] in {'a'..'z'}
  l.startPos = l.getColNumber l.bufpos
  setLen l.token, 0
  while true:
    if l.buf[l.bufpos] in {'a'..'z', 'A'..'Z', '0'..'9', '_'}:
      add l.token, l.buf[l.bufpos]
      inc l.bufpos
    else:
      break
  l.kind = case l.token
           of "if": tkKeywordIf
           of "else": tkKeywordElse
           of "while": tkKeywordWhile
           of "print": tkKeywordPrint
           of "putc": tkKeywordPutc
           else: tkIdentifier

proc getToken(l: var Lexer): TokenKind =
  l.kind = tkInvalid
  setLen l.token, 0
  skip l

  case l.buf[l.bufpos]
  of '*':
    l.kind = tkOpMultiply
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of '/':
    l.kind = tkOpDivide
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of '%':
    l.kind = tkOpMod
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of '+':
    l.kind = tkOpAdd
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of '-':
    l.kind = tkOpSubtract
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of '<':
    l.kind = tkOpLess
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
    if l.buf[l.bufpos] == '=':
      l.kind = tkOpLessEqual
      inc l.bufpos
  of '>':
    l.kind = tkOpGreater
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
    if l.buf[l.bufpos] == '=':
      l.kind = tkOpGreaterEqual
      inc l.bufpos
  of '=':
    l.kind = tkOpAssign
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
    if l.buf[l.bufpos] == '=':
      l.kind = tkOpEqual
      inc l.bufpos
  of '!':
    l.kind = tkOpNot
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
    if l.buf[l.bufpos] == '=':
      l.kind = tkOpNotEqual
      inc l.bufpos
  of '&':
    if l.buf[l.bufpos + 1] == '&':
      l.kind = tkOpAnd
      l.startPos = l.getColNumber l.bufpos
      inc l.bufpos, 2
    else:
      setError l, "Unrecognized character"
  of '|':
    if l.buf[l.bufpos + 1] == '|':
      l.kind = tkOpOr
      l.startPos = l.getColNumber l.bufpos
      inc l.bufpos, 2
    else:
      setError l, "Unrecognized character"
  of '(':
    l.kind = tkLeftParen
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of ')':
    l.kind = tkRightParen
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of '{':
    l.kind = tkLeftBrace
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of '}':
    l.kind = tkRightBrace
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of ';':
    l.kind = tkSemicolon
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of ',':
    l.kind = tkComma
    l.startPos = l.getColNumber l.bufpos
    inc l.bufpos
  of '\'': handleChar l
  of '"': handleString l
  of '0'..'9': handleNumber l
  of 'a'..'z', 'A'..'Z': handleIdent l
  of EndOfFile:
    l.startPos = l.getColNumber l.bufpos
    l.kind = tkEndOfInput
  else:
    setError l, "Unrecognized character"
  result = l.kind

when isMainModule:
  import os, strformat
  proc main() =
    var l: Lexer
    if paramCount() < 1:
      open l, newFileStream stdin
    else:
      open l, newFileStream paramStr(1)
    while l.getToken notin {tkInvalid}:
      stdout.write &"{l.lineNumber:5}  {l.startPos + 1:5} {l.kind:<14}"
      if l.kind in {tkIdentifier, tkInteger, tkString}:
        stdout.write &"  {l.token}"
      stdout.write '\n'
      if l.kind == tkEndOfInput:
        break
    if hasError l:
      echo &"({l.lineNumber},{l.getColNumber l.bufpos + 1}) {l.error}"
  main()
