define(`break',
   `define(`ulim',llim)')
define(`for',
   `ifelse($#,0,``$0'',
   `define(`ulim',$3)`'define(`llim',$2)`'ifelse(ifelse($3,`',1,
         `eval($2<=$3)'),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),ulim,`$4')')')')

for(`x',`1',`',
   `x`'ifelse(x,10,`break',`, ')')
