flex=: {{
  'A B'=.y
  'names values'=.|:":each B
  (":A),.' ',.names,.' ',.values
}}@lex

testcase3=: {{)n
/*
  All lexical tokens - not syntactically correct, but that will
  have to wait until syntax analysis
 */
/* Print   */  print    /* Sub     */  -
/* Putc    */  putc     /* Lss     */  <
/* If      */  if       /* Gtr     */  >
/* Else    */  else     /* Leq     */  <=
/* While   */  while    /* Geq     */  >=
/* Lbrace  */  {        /* Eq      */  ==
/* Rbrace  */  }        /* Neq     */  !=
/* Lparen  */  (        /* And     */  &&
/* Rparen  */  )        /* Or      */  ||
/* Uminus  */  -        /* Semi    */  ;
/* Not     */  !        /* Comma   */  ,
/* Mul     */  *        /* Assign  */  =
/* Div     */  /        /* Integer */  42
/* Mod     */  %        /* String  */  "String literal"
/* Add     */  +        /* Ident   */  variable_name
/* character literal */  '\n'
/* character literal */  '\\'
/* character literal */  ' '
}}

   flex testcase3
 5 16 Keyword_print
 5 40 Op_subtract
 6 16 Keyword_putc
 6 40 Op_less
 7 16 Keyword_if
 7 40 Op_greater
 8 16 Keyword_else
 8 40 Op_lessequal
 9 16 Keyword_while
 9 40 Op_greaterequal
10 16 LeftBrace
10 40 Op_equal
11 16 RightBrace
11 40 Op_notequal
12 16 LeftParen
12 40 Op_and
13 16 RightParen
13 40 Op_or
14 16 Op_subtract
14 40 Semicolon
15 16 Op_not
15 40 Comma
16 16 Op_multiply
16 40 Op_assign
17 16 Op_divide
17 40 Integer         42
18 16 Op_mod
18 40 String          "String literal"
19 16 Op_add
19 40 Identifier      variable_name
20 28 Identifier      10
21 28 Integer         92
22 27 Integer         32
23  1 End_of_input
