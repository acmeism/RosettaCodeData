divert(-1)
define(`randSeed',141592653)
define(`rand_t',`eval(randSeed^(randSeed>>13))')
define(`random',
   `define(`randSeed',eval((rand_t^(rand_t<<18))&0x7fffffff))randSeed')
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')
define(`set',`define(`$1[$2]',`$3')')
define(`get',`defn($1[$2])')
define(`new',`set($1,size,0)')
define(`deck',
   `new($1)for(`x',1,$2,
         `set(`$1',x,x)')`'set(`$1',size,$2)')
define(`show',
   `for(`x',1,get($1,size),`get($1,x)`'ifelse(x,get($1,size),`',`, ')')')
define(`swap',`set($1,$2,get($1,$4))`'set($1,$4,$3)')
define(`shuffle',
   `define(`s',get($1,size))`'for(`x',1,decr(s),
      `swap($1,x,get($1,x),eval(x+random%(s-x+1)))')')
divert

deck(`b',52)
show(`b')
shuffle(`b')
show(`b')
