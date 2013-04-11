define(`_set', `define(`$1[$2]', `$3')')dnl
define(`_get', `defn(`$1[$2]')')dnl
define(`for',`ifelse($#,0,``$0'',`ifelse(eval($2<=$3),1,
`pushdef(`$1',$2)$5`'popdef(`$1')$0(`$1',eval($2+$4),$3,$4,`$5')')')')dnl
define(`opposite',`_set(`door',$1,ifelse(_get(`door',$1),`closed',`open',`closed'))')dnl
define(`upper',`100')dnl
for(`x',`1',upper,`1',`_set(`door',x,`closed')')dnl
for(`x',`1',upper,`1',`for(`y',x,upper,x,`opposite(y)')')dnl
for(`x',`1',upper,`1',`door x is _get(`door',x)
')dnl
