divert(-1)
define(`set',`define(`$1[$2]',`$3')')
define(`get',`defn(`$1[$2]')')
define(`setrange',`ifelse(`$3',`',$2,`define($1[$2],$3)`'setrange($1,
   incr($2),shift(shift(shift($@))))')')

dnl  throw in sentinels at each end (0 and size+1) to make counting easy
define(`new',`set($1,size,eval($#-1))`'setrange($1,1,
   shift($@))`'set($1,0,0)`'set($1,$#,0)')

define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')
define(`show',
   `for(`k',1,get($1,size),`get($1,k) ')')

dnl  swap(`a',a,`b')  using arg stack for temp
define(`swap',`define(`$1',$3)`'define(`$3',$2)')
define(`nalive',
   `eval(get($1,decr($2))+get($1,incr($2)))')
setrange(`live',0,0,1,0)
setrange(`dead',0,0,0,1)
define(`nv',
   `ifelse(get($1,z),0,`get(dead,$3)',`get(live,$3)')')
define(`evolve',
   `for(`z',1,get($1,size),
      `set($2,z,nv($1,z,nalive($1,z)))')')
new(`a',0,1,1,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,0)
set(`b',size,get(`a',size))`'set(`b',0,0)`'set(`b',incr(get(`a',size)),0)
define(`x',`a')
define(`y',`b')
divert
for(`j',1,10,
   `show(x)`'evolve(`x',`y')`'swap(`x',x,`y')
')`'show(x)
