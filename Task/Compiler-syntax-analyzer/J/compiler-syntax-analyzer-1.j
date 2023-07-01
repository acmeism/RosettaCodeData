require'format/printf'

tkref=: tokenize 'End_of_input*/%+--<<=>>===!=!&&||print=print(if{else}while;,putc)a""0'
tkref,. (tknames)=: tknames=:;: {{)n
 End_of_input Op_multiply Op_divide Op_mod Op_add Op_subtract Op_negate Op_less
 Op_lessequal Op_greater Op_greaterequal Op_equal Op_notequal Op_not Op_and
 Op_or Keyword_print Op_assign Keyword_print LeftParen Keyword_if LeftBrace Keyword_else RightBrace
 Keyword_while Semicolon Comma Keyword_putc RightParen
 Identifier String Integer
}}-.LF

tkV=: 2 (tkref i.tokenize '*/%+-<<=>>===!=&&||')} (#tktyp)#0
tkV=: 1 (1 0+tkref i.tokenize '-!')} tkV
tkPrec=: 13 13 13 12 12 10 10 10 10 9 9 5 4 (tkref i.tokenize'*/%+-<<=>>==!=&&||')} tkV<._1
tkPrec=: 14 (1 0+tkref i.tokenize'-!')} tkPrec
NB. proofread |:(<"1 tkV,.tkPrec),tkref,:tknames

tkref,.(ndDisp)=: ndDisp=:;:{{)n
 Sequence Multiply Divide Mod Add Subtract Negate Less LessEqual Greater
 GreaterEqual Equal NotEqual Not And Or Prts Assign Prti x If x x x While
 x x Prtc x Identifier String Integer
}}-.LF
NB. proofread |:tkref,:ndDisp

gettoken=: {{
  'tok_ln tok_col'=: (0;ndx){::x
  'tok_name tok_value'=: (1;ndx){::x
  if. 'Error'-:tok_name do.
    error 'invalid word ',":tok_value
  end.
  ind=. tknames i.<tok_name
  tok_text=: ind{::tkref
  tok_valence=: ind{::tkV
  tok_precedence=: ind{::tkPrec
  ndx=:ndx+1
  node_display=: ind{::ndDisp
}}

parse=: {{
  ndx=: tok_ln=: tok_col=: 0
  gettok=: y&gettoken
  gettok''
  t=.a:
  whilst.-.(a:-:t)+.tok_name-:End_of_input do.
    t=. Sequence make_node t stmt''
  end.
}}

stmt=:{{)v
  t=. a:
  select.tok_name
    case.Keyword_if do.
      s=. stmt e=. paren_expr gettok''
      if.Keyword_else-:tok_name
      do.   S=. stmt gettok''
      else. S=. a: end.
      t=. If make_node e If make_node s S
    case.Keyword_putc do.
      e=. paren_expr gettok''
      t=. Prtc make_node e a:
      Prtc expect Semicolon
    case.Keyword_print do.gettok''
      'Print' expect LeftParen
      while.do.
        if.String-:tok_name
        do. gettok e=. Prts make_node (String make_leaf tok_value) a:
        else. e=. Prti make_node (expr 0) a: end.
        t=. Sequence make_node t e
        if.Comma-:tok_name
        do.Comma expect Comma
        else.break.end.
      end.
      'Print' expect RightParen
      'Print' expect Semicolon
    case.Semicolon do.gettok''
    case.Identifier do.
      gettok v=. Identifier make_leaf tok_value
      Assign expect Op_assign
      t=. Assign make_node v e=. expr 0
      Assign expect Semicolon
    case.Keyword_while do.
      t=. While make_node e s=. stmt e=. paren_expr gettok''
    case.LeftBrace do.
      'LeftBrace' expect LeftBrace
      while.-.(<tok_name) e.  RightBrace;End_of_input do.
        t=. Sequence make_node t stmt''
      end.
      'LeftBrace' expect RightBrace
    case.End_of_input do.
    case.do. error 'Expecting start of statement, found %s'sprintf<tok_text
  end.
  t
}}

paren_expr=: {{
  'paren_expr' expect LeftParen
  t=. expr 0
  'paren_expr' expect RightParen
  t
}}

not_prec=: tkPrec{~tknames i.<Op_not
expr=: {{
  select.tok_name
    case.LeftParen do.e=. paren_expr''
    case.Op_add do.gettok''
      e=. expr not_prec
    case.Op_subtract do.gettok''
      e=. Negate make_node (expr not_prec) a:
    case.Op_not do.gettok''
      e=. Not make_node (expr not_prec) a:
    case.Identifier do.
      gettok e=. Identifier make_leaf tok_value
    case.Integer do.
      gettok e=. Integer make_leaf tok_value
    case.do. error 'Expecting a primary, found %s'sprintf<tok_text
  end.
  while.(2=tok_valence)*tok_precedence>:y do.
    q=. 1+tok_precedence [ op=. node_display NB. no right associative operators
    gettok''
    node=. expr q
    e=. op make_node e node
  end.
  e
}}

expect=: {{
  if.y-:tok_name do. gettok'' return.end.
  error '%s: Expecting "%s", found "%s"'sprintf x;(tkref{::~tknames i.<y);tok_text
}}

make_leaf=: {{
  x;y
}}

make_node=: {{
  m;n;<y
}}

error=: {{
  echo 'Error: line %d, column %d: %s\n'sprintf tok_ln;tok_col;y throw.
}}


syntax=: {{
  ;(flatAST parse y),each LF
}}

flatAST=: {{
  assert.*L.y
  select.#y
    case.1 do.<';' assert.y-:a:
    case.2 do.<;:inv ":each y
    case.3 do.({.y),(flatAST 1{::y),flatAST 2{::y
    case.do.assert.0
  end.
}}
