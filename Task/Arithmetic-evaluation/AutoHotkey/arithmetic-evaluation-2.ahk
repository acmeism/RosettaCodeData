tokenize(string, lexer)
{
  stringo := string  ; store original string
  locationInString := 1
  size := strlen(string)
  tokens := object()

start:
  Enum := Lexer._NewEnum()
  While Enum[type, value]  ; loop through regular expression lexing rules
  {
    if (1 == regexmatch(string, value, tokenValue))
    {
      token := object()
      token.pos := locationInString
      token.value := tokenValue
      token.length := strlen(tokenValue)
      token.type := type
      tokens._Insert(token)
      locationInString += token.length
      string := substr(string, token.length + 1)
      goto start
    }
    continue
  }
  if (locationInString < size)
    msgbox % "unrecognized token at " substr(stringo, locationInstring)
  return tokens
}

makeCalcLexer()
{
  calcLexer := object()
  PLUS := "\+"
  MINUS := "-"
  MULT := "\*"
  DIV := "/"
  OPEN := "\("
  CLOSE := "\)"
  NUMBER := "\d+"
  WS := "[ \t\n]+"
  END := "\."
  RULES := "PLUS,MINUS,MULT,DIV,OPEN,CLOSE,NUMBER,WS,END"
  loop, parse, rules, `,
  {
    type := A_LoopField
    value := %A_LoopField%
    calcLexer._Insert(type, value)
  }
  return calcLexer
}

printTokens(tokens)
{
  loop % tokens._MaxIndex()
  {
    tokenString .= printToken(tokens[A_Index]) "`n`n"
  }
  return tokenString
}


printToken(token)
{
  string := "pos= " token.pos "`nvalue= " token.value "`ntype= " token.type
  return string
}
