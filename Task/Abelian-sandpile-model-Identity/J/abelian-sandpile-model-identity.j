While=:2 :'u^:(0-.@:-:v)^:_'
index_of_maximum=: $ #: (i. >./)@:,

frame=: ({.~ -@:>:@:$)@:({.~ >:@:$) :. ([;.0~ (1,:_2+$))
NEIGHBORS=: _2]\_1  0  0 _1  0  0  0  1  1  0
AVALANCHE =: 1 1 _4 1 1

avalanche=: (AVALANCHE + {)`[`]}~ ([: <"1 NEIGHBORS +"1 index_of_maximum)
erode=: avalanche&.:frame While(3 < [: >./ ,)
