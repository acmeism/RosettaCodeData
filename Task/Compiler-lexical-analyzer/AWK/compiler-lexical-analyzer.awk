BEGIN {
  all_syms["tk_EOI"    ] = "End_of_input"
  all_syms["tk_Mul"    ] = "Op_multiply"
  all_syms["tk_Div"    ] = "Op_divide"
  all_syms["tk_Mod"    ] = "Op_mod"
  all_syms["tk_Add"    ] = "Op_add"
  all_syms["tk_Sub"    ] = "Op_subtract"
  all_syms["tk_Negate" ] = "Op_negate"
  all_syms["tk_Not"    ] = "Op_not"
  all_syms["tk_Lss"    ] = "Op_less"
  all_syms["tk_Leq"    ] = "Op_lessequal"
  all_syms["tk_Gtr"    ] = "Op_greater"
  all_syms["tk_Geq"    ] = "Op_greaterequal"
  all_syms["tk_Eq"     ] = "Op_equal"
  all_syms["tk_Neq"    ] = "Op_notequal"
  all_syms["tk_Assign" ] = "Op_assign"
  all_syms["tk_And"    ] = "Op_and"
  all_syms["tk_Or"     ] = "Op_or"
  all_syms["tk_If"     ] = "Keyword_if"
  all_syms["tk_Else"   ] = "Keyword_else"
  all_syms["tk_While"  ] = "Keyword_while"
  all_syms["tk_Print"  ] = "Keyword_print"
  all_syms["tk_Putc"   ] = "Keyword_putc"
  all_syms["tk_Lparen" ] = "LeftParen"
  all_syms["tk_Rparen" ] = "RightParen"
  all_syms["tk_Lbrace" ] = "LeftBrace"
  all_syms["tk_Rbrace" ] = "RightBrace"
  all_syms["tk_Semi"   ] = "Semicolon"
  all_syms["tk_Comma"  ] = "Comma"
  all_syms["tk_Ident"  ] = "Identifier"
  all_syms["tk_Integer"] = "Integer"
  all_syms["tk_String" ] = "String"

  ## single character only symbols
  symbols["{"   ] = "tk_Lbrace"
  symbols["}"   ] = "tk_Rbrace"
  symbols["("   ] = "tk_Lparen"
  symbols[")"   ] = "tk_Rparen"
  symbols["+"   ] = "tk_Add"
  symbols["-"   ] = "tk_Sub"
  symbols["*"   ] = "tk_Mul"
  symbols["%"   ] = "tk_Mod"
  symbols[";"   ] = "tk_Semi"
  symbols[","   ] = "tk_Comma"

  key_words["if"   ] = "tk_If"
  key_words["else" ] = "tk_Else"
  key_words["print"] = "tk_Print"
  key_words["putc" ] = "tk_Putc"
  key_words["while"] = "tk_While"

  # Set up an array that emulates the ord() function.
  for(n=0;n<256;n++)
    ord[sprintf("%c",n)]=n

  input_file = "-"
  if (ARGC > 1)
    input_file = ARGV[1]
  RS=FS=""   # read complete file into one line $0
  getline < input_file
  the_ch = " " # dummy first char - but it must be a space
  the_col  = 0 # always points to the current character
  the_line = 1
  for (the_nf=1; ; ) {
    split(gettok(), t, SUBSEP)
    printf("%5s  %5s %-14s", t[2], t[3], all_syms[t[1]])
    if      (t[1] == "tk_Integer") printf("   %5s\n", t[4])
    else if (t[1] == "tk_Ident"  ) printf("  %s\n",   t[4])
    else if (t[1] == "tk_String" ) printf("  \"%s\"\n", t[4])
    else                           print("")
    if (t[1] == "tk_EOI")
      break
  }
}

#*** show error and exit
function error(line, col, msg) {
  print(line, col, msg)
  exit(1)
}

# get the next character from the input
function next_ch() {
  the_ch = $the_nf
  the_nf  ++
  the_col ++
  if (the_ch == "\n") {
    the_line ++
    the_col = 0
  }
  return the_ch
}

#*** 'x' - character constants
function char_lit(err_line, err_col) {
  n = ord[next_ch()]              # skip opening quote
  if (the_ch == "'") {
    error(err_line, err_col, "empty character constant")
  } else if (the_ch == "\\") {
    next_ch()
    if (the_ch == "n")
      n = 10
    else if (the_ch == "\\")
      n = ord["\\"]
    else
      error(err_line, err_col, "unknown escape sequence " the_ch)
  }
  if (next_ch() != "'")
    error(err_line, err_col, "multi-character constant")
  next_ch()
  return "tk_Integer" SUBSEP err_line SUBSEP err_col SUBSEP n
}

#*** process divide or comments
function div_or_cmt(err_line, err_col) {
  if (next_ch() != "*")
    return "tk_Div" SUBSEP err_line SUBSEP err_col
  # comment found
  next_ch()
  while (1) {
    if (the_ch == "*") {
      if (next_ch() == "/") {
        next_ch()
        return gettok()
      } else if (the_ch == "") {
        error(err_line, err_col, "EOF in comment")
      }
    } else {
      next_ch()
    }
  }
}

#*** "string"
function string_lit(start, err_line, err_col) {
  text = ""
  while (next_ch() != start) {
    if (the_ch == "")
      error(err_line, err_col, "EOF while scanning string literal")
    if (the_ch == "\n")
      error(err_line, err_col, "EOL while scanning string literal")
    text = text the_ch
  }
  next_ch()
  return "tk_String" SUBSEP err_line SUBSEP err_col SUBSEP text
}

#*** handle identifiers and integers
function ident_or_int(err_line, err_col) {
  is_number = 1
  text = ""
  while ((the_ch ~ /^[0-9a-zA-Z]+$/)  || (the_ch == "_")) {
    text = text the_ch
    if (! (the_ch ~ /^[0-9]+$/))
      is_number = 0
    next_ch()
  }
  if (text == "")
    error(err_line, err_col, "ident_or_int: unrecognized character: " the_ch)
  if (text ~ /^[0-9]/) {
    if (! is_number)
      error(err_line, err_col, "invalid number: " text)
    n = text + 0
    return "tk_Integer" SUBSEP err_line SUBSEP err_col SUBSEP n
  }
  if (text in key_words)
    return key_words[text] SUBSEP err_line SUBSEP err_col
  return "tk_Ident" SUBSEP err_line SUBSEP err_col SUBSEP text
}

#*** look ahead for '>=', etc.
function follow(expect, ifyes, ifno, err_line, err_col) {
  if (next_ch() == expect) {
    next_ch()
    return ifyes SUBSEP err_line SUBSEP err_col
  }
  if (ifno == tk_EOI)
    error(err_line, err_col, "follow: unrecognized character: " the_ch)
  return ifno SUBSEP err_line SUBSEP err_col
}

#*** return the next token type
function gettok() {
  while (the_ch == " " || the_ch == "\n" || the_ch == "\r")
    next_ch()
  err_line = the_line
  err_col  = the_col
  if      (the_ch == "" )    return "tk_EOI" SUBSEP err_line SUBSEP err_col
  else if (the_ch == "/")    return div_or_cmt(err_line, err_col)
  else if (the_ch == "'")    return char_lit(err_line, err_col)
  else if (the_ch == "<")    return follow("=", "tk_Leq", "tk_Lss",    err_line, err_col)
  else if (the_ch == ">")    return follow("=", "tk_Geq", "tk_Gtr",    err_line, err_col)
  else if (the_ch == "=")    return follow("=", "tk_Eq",  "tk_Assign", err_line, err_col)
  else if (the_ch == "!")    return follow("=", "tk_Neq", "tk_Not",    err_line, err_col)
  else if (the_ch == "&")    return follow("&", "tk_And", "tk_EOI",    err_line, err_col)
  else if (the_ch == "|")    return follow("|", "tk_Or",  "tk_EOI",    err_line, err_col)
  else if (the_ch =="\"")    return string_lit(the_ch, err_line, err_col)
  else if (the_ch in symbols) {
    sym = symbols[the_ch]
    next_ch()
    return sym SUBSEP err_line SUBSEP err_col
  } else {
    return ident_or_int(err_line, err_col)
  }
}
