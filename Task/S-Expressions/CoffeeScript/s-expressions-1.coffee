# This code works with Lisp-like s-expressions.
#
# We lex tokens then do recursive descent on the tokens
# to build our data structures.

sexp = (data) ->
  # Convert a JS data structure to a string s-expression.  A sexier version
  # would remove quotes around strings that don't need them.
  s = ''
  if Array.isArray data
    children = (sexp elem for elem in data).join ' '
    '(' + children + ')'
  else
    return JSON.stringify data

parse_sexp = (sexp) ->
  tokens = lex_sexp sexp
  i = 0

  _parse_list = ->
    i += 1
    arr = []
    while i < tokens.length and tokens[i].type != ')'
      arr.push _parse()
    if i < tokens.length
      i += 1
    else
     throw Error "missing end paren"
    arr

  _guess_type = (word) ->
    # This is crude, doesn't handle all forms of floats.
    if word.match /^\d+\.\d+$/
      parseFloat(word)
    else if word.match /^\d+/
      parseInt(word)
    else
      word

  _parse_word = ->
    token = tokens[i]
    i += 1
    if token.type == 'string'
      token.word
    else
      _guess_type token.word

  _parse = ->
    return undefined unless i < tokens.length
    token = tokens[i]
    if token.type == '('
      _parse_list()
    else
      _parse_word()

  exp = _parse()
  throw Error "premature termination" if i < tokens.length
  exp

lex_sexp = (sexp) ->
  is_whitespace = (c) -> c in [' ', '\t', '\n']
  i = 0
  tokens = []

  test = (f) ->
    return false unless i < sexp.length
    f(sexp[i])

  eat_char = (c) ->
    tokens.push
      type: c
    i += 1

  eat_whitespace = ->
    i += 1
    while test is_whitespace
      i += 1

  eat_word = ->
    token = c
    i += 1
    word_char = (c) ->
      c != ')' and !is_whitespace c
    while test word_char
      token += sexp[i]
      i += 1
    tokens.push
      type: "word"
      word: token

  eat_quoted_word = ->
    start = i
    i += 1
    token = ''
    while test ((c) -> c != '"')
      if sexp[i] == '\\'
        i += 1
        throw Error("escaping error") unless i < sexp.length
      token += sexp[i]
      i += 1
    if test ((c) -> c == '"')
      tokens.push
        type: "string"
        word: token
      i += 1
    else
      throw Error("end quote missing #{sexp.substring(start, i)}")

  while i < sexp.length
    c = sexp[i]
    if c == '(' or c == ')'
      eat_char c
    else if is_whitespace c
      eat_whitespace()
    else if c == '"'
      eat_quoted_word()
    else
      eat_word()
  tokens

do ->
  input = """
    ((data "quoted data with escaped \\"" 123 4.5 "14")
     (data (!@# (4.5) "(more" "data)")))
  """
  console.log "input:\n#{input}\n"
  output = parse_sexp(input)
  pp = (data) -> JSON.stringify data, null, '  '
  console.log "output:\n#{pp output}\n"
  console.log "round trip:\n#{sexp output}\n"
