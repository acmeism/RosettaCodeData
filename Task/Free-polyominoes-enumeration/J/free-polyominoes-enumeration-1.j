polyominoes=:verb define
  if. 1>y do. i.0 0 0 return.end.
  if. 1=y do. 1 1 1$'#' return.end.
  }.~.' ',simplify ,/extend"2 polyominoes y-1
)

extend=:verb define
  reps=. ' ',"1~~.all y
  simplify ,/extend1"2 reps
)

extend1=:verb define
  b=. (i.#y),._1|."1 '# ' E."1 y
  simplify ,/b extend2"1 _ y
)

extend2=:verb define
:
  row=.{.x
  mask=.}.x
  row mask extend3 y&>1+i.+/mask
)

extend3=:conjunction define
:
  '#' (<x,I.m*y=+/\m)} n
)

simplify=:verb define
  t=. ~.trim"2 y
  t #~ +./"1 ((2{.$) $ (i.@# = i.~)@(,/)) all@trim"2 t
)

flip=: |."_1
all=: , flip@|:, |.@flip, |.@|:, |., |.@flip@|:, flip,: |:

trim=:verb define&|:^:2
  y#~+./"1 y~:' '
)
