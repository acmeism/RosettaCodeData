function Token_assign(tk, attr,      attr_array, n, i) {
  n=split(attr, attr_array)
  for(i=1; i<=n; i++)
    Tokens[tk,i-1] = attr_array[i]
}

#*** show error and exit
function error(msg) {
  printf("(%s, %s) %s\n", err_line, err_col, msg)
  exit(1)
}

function gettok(      line, n, i) {
  getline line
  if (line == "")
    error("empty line")
  n=split(line, line_list)
  # line col Ident var_name
  # 1    2   3     4
  err_line = line_list[1]
  err_col  = line_list[2]
  tok_text = line_list[3]
  tok = all_syms[tok_text]
  for (i=5; i<=n; i++)
    line_list[4] = line_list[4] " " line_list[i]
  if (tok == "")
    error("Unknown token " tok_text)
  tok_other = ""
  if (tok == "tk_Integer" || tok == "tk_Ident" || tok =="tk_String")
    tok_other = line_list[4]
}

function make_node(oper, left, right, value) {
  node_type [next_free_node_index] = oper
  node_left [next_free_node_index] = left
  node_right[next_free_node_index] = right
  node_value[next_free_node_index] = value
  return next_free_node_index ++
}

function make_leaf(oper, n) {
  return make_node(oper, 0, 0, n)
}

function expect(msg, s) {
  if (tok == s) {
    gettok()
    return
  }
  error(msg ": Expecting '" Tokens[s,TK_NAME] "', found '" Tokens[tok,TK_NAME] "'")
}

function expr(p,       x, op, node) {
  x = 0
  if (tok == "tk_Lparen") {
    x = paren_expr()
  } else if (tok == "tk_Sub" || tok == "tk_Add") {
    if (tok == "tk_Sub")
      op = "tk_Negate"
    else
      op = "tk_Add"
    gettok()
    node = expr(Tokens["tk_Negate",TK_PRECEDENCE]+0)
    if (op == "tk_Negate")
      x = make_node("nd_Negate", node)
    else
      x = node
  } else if (tok == "tk_Not") {
    gettok()
    x = make_node("nd_Not", expr(Tokens["tk_Not",TK_PRECEDENCE]+0))
  } else if (tok == "tk_Ident") {
    x = make_leaf("nd_Ident", tok_other)
    gettok()
  } else if (tok == "tk_Integer") {
    x = make_leaf("nd_Integer", tok_other)
    gettok()
  } else {
    error("Expecting a primary, found: " Tokens[tok,TK_NAME])
  }
  while (((Tokens[tok,TK_IS_BINARY]+0) > 0) && ((Tokens[tok,TK_PRECEDENCE]+0) >= p)) {
    op = tok
    gettok()
    q = Tokens[op,TK_PRECEDENCE]+0
    if (! (Tokens[op,TK_RIGHT_ASSOC]+0 > 0))
      q += 1
    node = expr(q)
    x = make_node(Tokens[op,TK_NODE], x, node)
  }
  return x
}

function paren_expr(        node) {
  expect("paren_expr", "tk_Lparen")
  node = expr(0)
  expect("paren_expr", "tk_Rparen")
  return node
}

function stmt(              t, e, s, s2, v) {
  t = 0
  if (tok == "tk_If") {
    gettok()
    e = paren_expr()
    s = stmt()
    s2 = 0
    if (tok == "tk_Else") {
      gettok()
      s2 = stmt()
    }
    t = make_node("nd_If", e, make_node("nd_If", s, s2))
  } else if (tok == "tk_Putc") {
    gettok()
    e = paren_expr()
    t = make_node("nd_Prtc", e)
    expect("Putc", "tk_Semi")
  } else if (tok == "tk_Print") {
    gettok()
    expect("Print", "tk_Lparen")
    while (1) {
      if (tok == "tk_String") {
        e = make_node("nd_Prts", make_leaf("nd_String", tok_other))
        gettok()
      } else {
        e = make_node("nd_Prti", expr(0))
      }
      t = make_node("nd_Sequence", t, e)
      if (tok != "tk_Comma")
        break
      gettok()
    }
    expect("Print", "tk_Rparen")
    expect("Print", "tk_Semi")
  } else if (tok == "tk_Semi") {
    gettok()
  } else if (tok == "tk_Ident") {
    v = make_leaf("nd_Ident", tok_other)
    gettok()
    expect("assign", "tk_Assign")
    e = expr(0)
    t = make_node("nd_Assign", v, e)
    expect("assign", "tk_Semi")
  } else if (tok == "tk_While") {
    gettok()
    e = paren_expr()
    s = stmt()
    t = make_node("nd_While", e, s)
  } else if (tok == "tk_Lbrace") {
    gettok()
    while (tok != "tk_Rbrace" && tok != "tk_EOI")
      t = make_node("nd_Sequence", t, stmt())
    expect("Lbrace", "tk_Rbrace")
  } else if (tok == "tk_EOI") {
  } else {
    error("Expecting start of statement, found: " Tokens[tok,TK_NAME])
  }
  return t
}

function parse(         t) {
  t = 0   # None
  gettok()
  while (1) {
    t = make_node("nd_Sequence", t, stmt())
    if (tok == "tk_EOI" || t == 0)
      break
  }
  return t
}

function prt_ast(t) {
  if (t == 0) {
    print(";")
  } else {
    printf("%-14s", Display_nodes[node_type[t]])
    if ((node_type[t] == "nd_Ident") || (node_type[t] == "nd_Integer"))
      printf("%s\n", node_value[t])
    else if (node_type[t] == "nd_String") {
      printf("%s\n", node_value[t])
    } else {
      print("")
      prt_ast(node_left[t])
      prt_ast(node_right[t])
    }
  }
}

BEGIN {
  all_syms["End_of_input"    ] = "tk_EOI"
  all_syms["Op_multiply"     ] = "tk_Mul"
  all_syms["Op_divide"       ] = "tk_Div"
  all_syms["Op_mod"          ] = "tk_Mod"
  all_syms["Op_add"          ] = "tk_Add"
  all_syms["Op_subtract"     ] = "tk_Sub"
  all_syms["Op_negate"       ] = "tk_Negate"
  all_syms["Op_not"          ] = "tk_Not"
  all_syms["Op_less"         ] = "tk_Lss"
  all_syms["Op_lessequal"    ] = "tk_Leq"
  all_syms["Op_greater"      ] = "tk_Gtr"
  all_syms["Op_greaterequal" ] = "tk_Geq"
  all_syms["Op_equal"        ] = "tk_Eq"
  all_syms["Op_notequal"     ] = "tk_Neq"
  all_syms["Op_assign"       ] = "tk_Assign"
  all_syms["Op_and"          ] = "tk_And"
  all_syms["Op_or"           ] = "tk_Or"
  all_syms["Keyword_if"      ] = "tk_If"
  all_syms["Keyword_else"    ] = "tk_Else"
  all_syms["Keyword_while"   ] = "tk_While"
  all_syms["Keyword_print"   ] = "tk_Print"
  all_syms["Keyword_putc"    ] = "tk_Putc"
  all_syms["LeftParen"       ] = "tk_Lparen"
  all_syms["RightParen"      ] = "tk_Rparen"
  all_syms["LeftBrace"       ] = "tk_Lbrace"
  all_syms["RightBrace"      ] = "tk_Rbrace"
  all_syms["Semicolon"       ] = "tk_Semi"
  all_syms["Comma"           ] = "tk_Comma"
  all_syms["Identifier"      ] = "tk_Ident"
  all_syms["Integer"         ] = "tk_Integer"
  all_syms["String"          ] = "tk_String"

  Display_nodes["nd_Ident"   ] = "Identifier"
  Display_nodes["nd_String"  ] = "String"
  Display_nodes["nd_Integer" ] = "Integer"
  Display_nodes["nd_Sequence"] = "Sequence"
  Display_nodes["nd_If"      ] = "If"
  Display_nodes["nd_Prtc"    ] = "Prtc"
  Display_nodes["nd_Prts"    ] = "Prts"
  Display_nodes["nd_Prti"    ] = "Prti"
  Display_nodes["nd_While"   ] = "While"
  Display_nodes["nd_Assign"  ] = "Assign"
  Display_nodes["nd_Negate"  ] = "Negate"
  Display_nodes["nd_Not"     ] = "Not"
  Display_nodes["nd_Mul"     ] = "Multiply"
  Display_nodes["nd_Div"     ] = "Divide"
  Display_nodes["nd_Mod"     ] = "Mod"
  Display_nodes["nd_Add"     ] = "Add"
  Display_nodes["nd_Sub"     ] = "Subtract"
  Display_nodes["nd_Lss"     ] = "Less"
  Display_nodes["nd_Leq"     ] = "LessEqual"
  Display_nodes["nd_Gtr"     ] = "Greater"
  Display_nodes["nd_Geq"     ] = "GreaterEqual"
  Display_nodes["nd_Eql"     ] = "Equal"
  Display_nodes["nd_Neq"     ] = "NotEqual"
  Display_nodes["nd_And"     ] = "And"
  Display_nodes["nd_Or"      ] = "Or"

  TK_NAME         =          0
  TK_RIGHT_ASSOC  =                   1
  TK_IS_BINARY    =                     2
  TK_IS_UNARY     =                       3
  TK_PRECEDENCE   =                          4
  TK_NODE         =                             5
  Token_assign("tk_EOI"    , "EOI     0 0 0 -1 -1        ")
  Token_assign("tk_Mul"    , "*       0 1 0 13 nd_Mul    ")
  Token_assign("tk_Div"    , "/       0 1 0 13 nd_Div    ")
  Token_assign("tk_Mod"    , "%       0 1 0 13 nd_Mod    ")
  Token_assign("tk_Add"    , "+       0 1 0 12 nd_Add    ")
  Token_assign("tk_Sub"    , "-       0 1 0 12 nd_Sub    ")
  Token_assign("tk_Negate" , "-       0 0 1 14 nd_Negate ")
  Token_assign("tk_Not"    , "!       0 0 1 14 nd_Not    ")
  Token_assign("tk_Lss"    , "<       0 1 0 10 nd_Lss    ")
  Token_assign("tk_Leq"    , "<=      0 1 0 10 nd_Leq    ")
  Token_assign("tk_Gtr"    , ">       0 1 0 10 nd_Gtr    ")
  Token_assign("tk_Geq"    , ">=      0 1 0 10 nd_Geq    ")
  Token_assign("tk_Eql"    , "==      0 1 0  9 nd_Eql    ")
  Token_assign("tk_Neq"    , "!=      0 1 0  9 nd_Neq    ")
  Token_assign("tk_Assign" , "=       0 0 0 -1 nd_Assign ")
  Token_assign("tk_And"    , "&&      0 1 0  5 nd_And    ")
  Token_assign("tk_Or"     , "||      0 1 0  4 nd_Or     ")
  Token_assign("tk_If"     , "if      0 0 0 -1 nd_If     ")
  Token_assign("tk_Else"   , "else    0 0 0 -1 -1        ")
  Token_assign("tk_While"  , "while   0 0 0 -1 nd_While  ")
  Token_assign("tk_Print"  , "print   0 0 0 -1 -1        ")
  Token_assign("tk_Putc"   , "putc    0 0 0 -1 -1        ")
  Token_assign("tk_Lparen" , "(       0 0 0 -1 -1        ")
  Token_assign("tk_Rparen" , ")       0 0 0 -1 -1        ")
  Token_assign("tk_Lbrace" , "{       0 0 0 -1 -1        ")
  Token_assign("tk_Rbrace" , "}       0 0 0 -1 -1        ")
  Token_assign("tk_Semi"   , ";       0 0 0 -1 -1        ")
  Token_assign("tk_Comma"  , ",       0 0 0 -1 -1        ")
  Token_assign("tk_Ident"  , "Ident   0 0 0 -1 nd_Ident  ")
  Token_assign("tk_Integer", "Integer 0 0 0 -1 nd_Integer")
  Token_assign("tk_String" , "String  0 0 0 -1 nd_String ")

  input_file = "-"
  err_line   = 0
  err_col    = 0
  tok        = ""
  tok_text   = ""
  next_free_node_index = 1

  if (ARGC > 1)
    input_file = ARGV[1]
  t = parse()
  prt_ast(t)
}
