import re, strformat, strutils

type
  TokenKind = enum
    tkUnknown = "UNKNOWN_TOKEN",
    tkMul = "Op_multiply",
    tkDiv = "Op_divide",
    tkMod = "Op_mod",
    tkAdd = "Op_add",
    tkSub = "Op_subtract",
    tkNeg = "Op_negate",
    tkLt = "Op_less",
    tkLte = "Op_lessequal",
    tkGt = "Op_greater",
    tkGte = "Op_greaterequal",
    tkEq = "Op_equal",
    tkNeq = "Op_notequal",
    tkNot = "Op_not",
    tkAsgn = "Op_assign",
    tkAnd = "Op_and",
    tkOr = "Op_or",
    tkLpar = "LeftParen",
    tkRpar = "RightParen",
    tkLbra = "LeftBrace",
    tkRbra = "RightBrace",
    tkSmc = "Semicolon",
    tkCom = "Comma",
    tkIf = "Keyword_if",
    tkElse = "Keyword_else",
    tkWhile = "Keyword_while",
    tkPrint = "Keyword_print",
    tkPutc = "Keyword_putc",
    tkId = "Identifier",
    tkInt = "Integer",
    tkChar = "Integer",
    tkStr = "String",
    tkEof = "End_of_input"

  Token = object
    kind: TokenKind
    value: string

  TokenAnn = object
    ## Annotated token with messages for compiler
    token: Token
    line, column: int

proc getSymbols(table: openArray[(char, TokenKind)]): seq[char] =
  result = newSeq[char]()
  for ch, tokenKind in items(table):
    result.add ch

const
  tkSymbols = { # single-char tokens
    '*': tkMul,
    '%': tkMod,
    '+': tkAdd,
    '-': tkSub,
    '(': tkLpar,
    ')': tkRpar,
    '{': tkLbra,
    '}': tkRbra,
    ';': tkSmc,
    ',': tkCom,
    '/': tkDiv, # the comment case /* ... */ is handled in `stripUnimportant`
  }
  symbols = getSymbols(tkSymbols)

proc findTokenKind(table: openArray[(char, TokenKind)]; needle: char):
                  TokenKind =
  for ch, tokenKind in items(table):
    if ch == needle: return tokenKind
  tkUnknown

proc stripComment(text: var string, lineNo, colNo: var int) =
  var matches: array[1, string]

  if match(text, re"\A(/\*[\s\S]*?\*/)", matches):
    text = text[matches[0].len..^1]
    for s in matches[0]:
      if s == '\n':
        inc lineNo
        colNo = 1
      else:
        inc colNo

proc stripUnimportant(text: var string; lineNo, colNo: var int) =
  while true:
    if text.len == 0: return
    elif text[0] == '\n':
      inc lineNo
      colNo = 1
      text = text[1..^1]
    elif text[0] == ' ':
      inc colNo
      text = text[1..^1]
    elif text.len >= 2 and text[0] == '/' and text[1] == '*':
      stripComment(text, lineNo, colNo)
    else: return

proc lookAhead(ch1, ch2: char, tk1, tk2: TokenKind): (TokenKind, int) =
  if ch1 == ch2: (tk1, 2)
  else: (tk2, 1)

proc consumeToken(text: var string; tkl: var int): Token =
  ## Return token removing it from the `text` and write its length to
  ## `tkl`.  If the token can not be defined, return `tkUnknown` as a
  ## token, shrink text by 1 and write 1 to its length.

  var
    matches: array[1, string]
    tKind: TokenKind
    val: string

  if text.len == 0:
    (tKind, tkl) = (tkEof, 0)

  # Simple characters
  elif text[0] in symbols: (tKind, tkl) = (tkSymbols.findTokenKind(text[0]), 1)
  elif text[0] == '<': (tKind, tkl) = lookAhead(text[1], '=', tkLte, tkLt)
  elif text[0] == '>': (tKind, tkl) = lookAhead(text[1], '=', tkGte, tkGt)
  elif text[0] == '=': (tKind, tkl) = lookAhead(text[1], '=', tkEq, tkAsgn)
  elif text[0] == '!': (tKind, tkl) = lookAhead(text[1], '=', tkNeq, tkNot)
  elif text[0] == '&': (tKind, tkl) = lookAhead(text[1], '&', tkAnd, tkUnknown)
  elif text[0] == '|': (tKind, tkl) = lookAhead(text[1], '|', tkOr, tkUnknown)

  # Keywords
  elif match(text, re"\Aif\b"): (tKind, tkl) = (tkIf, 2)
  elif match(text, re"\Aelse\b"): (tKind, tkl) = (tkElse, 4)
  elif match(text, re"\Awhile\b"): (tKind, tkl) = (tkWhile, 5)
  elif match(text, re"\Aprint\b"): (tKind, tkl) = (tkPrint, 5)
  elif match(text, re"\Aputc\b"): (tKind, tkl) = (tkPutc, 4)

  # Literals and identifiers
  elif match(text, re"\A([0-9]+)", matches):
    (tKind, tkl) = (tkInt, matches[0].len)
    val = matches[0]
  elif match(text, re"\A([_a-zA-Z][_a-zA-Z0-9]*)", matches):
    (tKind, tkl) = (tkId, matches[0].len)
    val = matches[0]
  elif match(text, re"\A('(?:[^'\n]|\\\\|\\n)')", matches):
    (tKind, tkl) = (tkChar, matches[0].len)
    val = case matches[0]
          of r"' '": $ord(' ')
          of r"'\n'": $ord('\n')
          of r"'\\'": $ord('\\')
          else: $ord(matches[0][1]) # "'a'"[1] == 'a'
  elif match(text, re"\A(""[^""\n]*"")", matches):
    (tKind, tkl) = (tkStr, matches[0].len)
    val = matches[0]
  else: (tKind, tkl) = (tkUnknown, 1)

  text = text[tkl..^1]
  Token(kind: tKind, value: val)

proc tokenize*(text: string): seq[TokenAnn] =
  result = newSeq[TokenAnn]()
  var
    lineNo, colNo: int = 1
    text = text
    token: Token
    tokenLength: int

  while text.len > 0:
    stripUnimportant(text, lineNo, colNo)
    token = consumeToken(text, tokenLength)
    result.add TokenAnn(token: token, line: lineNo, column: colNo)
    inc colNo, tokenLength

proc output*(s: seq[TokenAnn]): string =
  var
    tokenKind: TokenKind
    value: string
    line, column: int

  for tokenAnn in items(s):
    line = tokenAnn.line
    column = tokenAnn.column
    tokenKind = tokenAnn.token.kind
    value = tokenAnn.token.value
    result.add(
      fmt"{line:>5}{column:>7} {tokenKind:<15}{value}"
        .strip(leading = false) & "\n")

when isMainModule:
  import os

  let input = if paramCount() > 0: readFile paramStr(1)
              else: readAll stdin

  echo input.tokenize.output
