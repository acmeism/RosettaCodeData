parse=:parse_parser_
eval=:monad define
  'gerund structure'=:y
  gerund@.structure
)

coclass 'parser'
classify=: '$()*/+-'&(((>:@#@[ # 2:) #: 2 ^ i.)&;:)

rules=: ''
patterns=: ,"0 assert 1

addrule=: dyad define
   rules=: rules,;:x
   patterns=: patterns,+./@classify"1 y
)

'Term'   addrule '$()',   '0',     '+-',: '0'
'Factor' addrule '$()+-', '0',     '*/',: '0'
'Parens' addrule '(',    '*/+-0', ')',:  ')*/+-0$'
rules=: rules,;:'Move'

buildTree=: monad define
  words=: ;:'$',y
  queue=: classify '$',y
  stack=: classify '$$$$'
  tokens=: ]&.>i.#words
  tree=: ''
  while.(#queue)+.6<#stack do.
    rule=: rules {~ i.&1 patterns (*./"1)@:(+./"1) .(*."1)4{.stack
    rule`:6''
  end.
  'syntax' assert 1 0 1 1 1 1 -: {:"1 stack
  gerund=: literal&.> (<,'%') (I. words=<,'/')} words
  gerund;1{tree
)

literal=:monad define ::]
  ".'t=.',y
  5!:1<'t'
)

Term=: Factor=: monad define
  stack=: ({.stack),(classify '0'),4}.stack
  tree=: ({.tree),(<1 2 3{tree),4}.tree
)

Parens=: monad define
  stack=: (1{stack),3}.stack
  tree=: (1{tree),3}.tree
)

Move=: monad define
  'syntax' assert 0<#queue
  stack=: ({:queue),stack
  queue=: }:queue
  tree=: ({:tokens),tree
  tokens=: }:tokens
)

parse=:monad define
  tmp=: conew 'parser'
  r=: buildTree__tmp y
  coerase tmp
  r
)
