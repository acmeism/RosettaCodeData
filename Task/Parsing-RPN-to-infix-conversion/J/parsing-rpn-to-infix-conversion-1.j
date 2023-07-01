tokenize=: ' ' <;._1@, deb

ops=: ;:'+ - * / ^'
doOp=: plus`minus`times`divide`exponent`push@.(ops&i.)
parse=:3 :0
  stack=: i.0 2
  for_token.tokenize y do.doOp token end.
  1{:: ,stack
)

parens=:4 :0
  if. y do. '( ',x,' )' else. x end.
)

NB. m: precedence, n: is right associative, y: token
op=:2 :0
  L=. m -   n
  R=. m - -.n
  smoutput;'operation: ';y
  'Lprec left Rprec right'=. ,_2{.stack
  expr=. ;(left parens L > Lprec);' ';y,' ';right parens R > Rprec
  stack=: (_2}.stack),m;expr
  smoutput stack
)

plus=:     2 op 0
minus=:    2 op 0
times=:    3 op 0
divide=:   3 op 0
exponent=: 4 op 1

push=:3 :0
  smoutput;'pushing: ';y
  stack=: stack,_;y
  smoutput stack
)
