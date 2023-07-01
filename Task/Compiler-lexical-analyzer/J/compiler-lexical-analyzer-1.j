symbols=:256#0
ch=: {{1 0+x[symbols=: x (a.i.y)} symbols}}
'T0 token'  =: 0 ch '%+-!(){};,<>=!|&'
'L0 letter' =: 1 ch '_',,u:65 97+/i.26
'D0 digit'  =: 2 ch u:48+i.10
'S0 space'  =: 3 ch ' ',LF
'C0 commen' =: 4 ch '/'
'C1 comment'=: 5 ch '*'
'q0 quote'  =: 6 ch ''''
'Q0 dquote' =: 7 ch '"'

width=: 1+>./symbols
default=: ,:(1+i.width),every 2
states=:((1+i.width),every 1),width#default
extend=: {{
  if.y>#states do.states=: y{.states,y#default
  end.states
}}
pad=: {{if. 0=#y do.y=.#states end.y}}
function=: {{ NB. x: before, m: op, n: symbol, y: after
  y[states=: (y,m) (<x,n)} extend 1+x>.y=.pad y
}}
{{for_op.y do.(op)=: op_index function end.0}};:'nop init start'
all=: {{y=.pad y
  for_symbol.i.width do.
    x symbol nop y
  end.y
}}
any=: {{y=.pad y
  for_symbol.i.width do.
    x symbol start y
  end.y
}}

NB. identifiers and keywords
     L0  letter nop L0
     L0   digit nop L0

NB. numbers
     D0   digit nop D0
     D0  letter nop D0

NB. white space
     S0   space nop S0

NB. comments
C1=: C0 comment nop ''
C2=: C1         all ''
     C2         all C2
C3=: C2  commen nop ''
C4=: C3 comment nop ''

NB. quoted characters
q1=: q0         any ''

NB. strings
Q1=: Q0         all ''
     Q1         all Q1
Q2=: Q1  dquote nop ''
     Q0  dquote nop Q2

tokenize=:{{
  tok=. (0;states;symbols);:y
  for_fix.cut'<= >= == != && ||'do.
    M=.;:;fix
    for_k.|.I.M E.tok do.
      tok=.(fix,<'') (0 1+k)} tok
    end.
  end.tok-.a:
}}

(tknames=:;: {{)n
 Op_multiply Op_divide Op_mod Op_add Op_subtract Op_less Op_lessequal
 Op_greater Op_greaterequal Op_equal Op_notequal Op_not Op_and Op_or
 Op_assign LeftParen RightParen Keyword_if LeftBrace Keyword_else
 RightBrace Keyword_while Semicolon Keyword_print Comma Keyword_putc
}}-.LF)=: tkref=: tokenize '*/%+-<<=>>===!=!&&||=()if{else}while;print,putc'
NB. the reference tokens here were arranged to avoid whitespace tokens
NB. also, we reserve multiple token instances where a literal string
NB. appears in different syntactic productions. Here, we only use the initial
NB. instances -- the others will be used in the syntax analyzer which
NB. uses the same tkref and tknames,

shift=: |.!.0
numvals=: {{
  ndx=. I.(0<#@>y)**/@> y e.L:0 '0123456789'
  ({{".y,'x'}}each ndx{y) ndx} y
}}
chrvals=: {{
  q=. y=<,''''
  s=. y=<,'\'
  j=. I.(-.s)*(1&shift * _1&shift)q
  k=. I.(y e.;:'\n')*(1 shift q)*(_2 shift q)*_1 shift s
  jvals=. a.i.L:0 j{y      NB. not escaped
  kvals=. (k{s){<"0 a.i.LF,'\' NB. escaped
  (,a:,jvals,:a:) (,_1 0 1+/j)} (,a:,a:,kvals,:a:) (,_2 _1 0 1+/k)} y
}}

validstring=: ((1<#)*('"'={.)*('"'={:)*('\'=])-:'\n'&E.(+._1&shift)@+.'\\'&E.) every

validid=: ((<,'\')~:_1&|.) * (e.&tkref) < (e.&(u:I.symbols=letter)@{. * */@(e.&(u:I.symbols e.letter,digit))@}.) every

lex=: {{
  lineref=.I.y=LF
  tokens=.(tokenize y),<,'_'
  offsets=.0,}:#@;\tokens
  lines=. lineref I.offsets
  columns=. offsets-lines{0,lineref
  keep=. -.({.@> tokens)e.u:I.space=symbols
  names=. (<'End_of_input') _1} (tkref i.tokens) {(_3}.tknames),4#<'Error'
  unknown=. names=<'Error'
  values=. a: _1} unknown#inv  numvals chrvals unknown#tokens
  names=. (<'Integer') (I.(values~:a:)*tokens~:values)} names
  names=. (<'String') (I.validstring tokens)} names
  names=. (<'Identifier') (I.validid tokens)} names
  names=. (<'End_of_input') _1} names
  comments=. '*/'&-:@(_2&{.)@> tokens
  whitespace=. (values=tokens) * e.&(' ',LF)@{.@> tokens
  keep=. (tokens~:<,'''')*-.comments+.whitespace+.unknown*a:=values
  keep&#each ((1+lines),.columns);<names,.values
}}
