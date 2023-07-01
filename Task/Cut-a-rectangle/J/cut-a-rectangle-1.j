init=: - {. 1:               NB. initial state: 1 square choosen
prop=: < {:,~2 ~:/\ ]        NB. propagate: neighboring squares (vertically)
poss=: I.@,@(prop +. prop"1 +. prop&.|. +. prop&.|."1)
keep=: poss -. <:@#@, - I.@, NB. symmetrically valid possibilities
N=: <:@-:@#@,                NB. how many neighbors to add
step=: [: ~.@;  <@(((= i.@$) +. ])"0 _~ keep)"2
all=: step^:N@init
