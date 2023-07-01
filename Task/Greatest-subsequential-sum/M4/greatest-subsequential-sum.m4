divert(-1)
define(`setrange',`ifelse(`$3',`',$2,`define($1[$2],$3)`'setrange($1,
   incr($2),shift(shift(shift($@))))')')
define(`asize',decr(setrange(`a',1,-1,-2,3,5,6,-2,-1,4,-4,2,-1)))
define(`get',`defn(`$1[$2]')')
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')
define(`maxsum',0)
for(`x',1,asize,
   `define(`sum',0)`'for(`y',x,asize,
      `define(`sum',eval(sum+get(`a',y)))`'ifelse(eval(sum>maxsum),1,
         `define(`maxsum',sum)`'define(`xmax',x)`'define(`ymax',y)')')')
divert
for(`x',xmax,ymax,`get(`a',x) ')
