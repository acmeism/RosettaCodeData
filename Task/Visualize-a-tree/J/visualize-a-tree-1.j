BOXC=: 9!:6 ''    NB. box drawing characters
EW  =: {: BOXC    NB. east-west

showtree=: 4 : 0
 NB. y is parent index for each node (non-indices for root nodes)
 NB. x is label for each node
 t=. (<EW,' ') ,@<@,:@,&":&.> x        NB. tree fragments
 c=. |:(#~ e./@|:);(~.,"0&.>(</. i.@#)) y
 while. +./ b=. ({.c)*.//.-.e.~/c do.
  i=. b#~.{.c                          NB. parents whose children are leaves
  j=. </./(({.c)e.i)#"1 c              NB. leaves grouped by parents
  t=. a: (;j)}t i}~ (i{t) subtree&.> j{&.><t
  c=. (-.({.c)e.i)#"1 c                NB. prune edges to leaves
 end.
 ;([: ,.&.>/ extend&.>)&> t -. a:
)

subtree=: 4 : 0
 p=. EW={."1 s=. >{.t=. graft y
 (<(>{.x) root p),(<(connect p),.s),}.t
)

graft=: 3 : 0
 n=. (-~ >./) #&> y
 f=. i.@(,&0)@#&.>@{.&.> y
 ,&.>/ y ,&> n$&.>f
)

connect=: 3 : 0
 b=. (+./\ *. +./\.) y
 c=. (b+2*y){' ',9 3 3{BOXC  NB. │ NS ├ E
 c=. (0{BOXC) (b i. 1)}c     NB. ┌ NW
 c=. (6{BOXC) (b i: 1)}c     NB. └ SW
 j=. (b i. 1)+<.-:+/b
 EW&(j})^:(1=+/b) c j}~ ((0 3 6 9{BOXC)i.j{c){1 4 7 5{BOXC
)

root=: 4 : 0
 j=. k+<.-:1+(y i: 1)-k=. y i. 1
 (-j)|.(#y){.x,.,:' ',EW
)

extend=: 3 : '(+./\"1 (y=EW) *. *./\."1 y e.'' '',EW)}y,:EW'
