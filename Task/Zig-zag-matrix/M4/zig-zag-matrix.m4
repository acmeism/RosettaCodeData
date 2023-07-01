divert(-1)

define(`set2d',`define(`$1[$2][$3]',`$4')')
define(`get2d',`defn(`$1[$2][$3]')')
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')
define(`show2d',
   `for(`x',0,decr($2),
      `for(`y',0,decr($3),`format(`%2d',get2d($1,x,y)) ')
')')

dnl  <name>,<size>
define(`zigzag',
   `define(`j',1)`'define(`k',1)`'for(`e',0,eval($2*$2-1),
      `set2d($1,decr(j),decr(k),e)`'ifelse(eval((j+k)%2),0,
         `ifelse(eval(k<$2),1,
            `define(`k',incr(k))',
            `define(`j',eval(j+2))')`'ifelse(eval(j>1),1,
            `define(`j',decr(j))')',
         `ifelse(eval(j<$2),1,
            `define(`j',incr(j))',
            `define(`k',eval(k+2))')`'ifelse(eval(k>1),1,
            `define(`k',decr(k))')')')')

divert

zigzag(`a',5)
show2d(`a',5,5)
