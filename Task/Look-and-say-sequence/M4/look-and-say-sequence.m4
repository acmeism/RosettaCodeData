divert(-1)
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')

define(`las',
   `patsubst(`$1',`\(\(.\)\2*\)',`len(\1)`'\2')')


define(`v',1)
divert
for(`x',1,10,
   `v
define(`v',las(v))')dnl
v
