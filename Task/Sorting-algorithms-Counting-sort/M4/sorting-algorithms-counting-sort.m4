divert(-1)

define(`randSeed',141592653)
define(`setRand',
   `define(`randSeed',ifelse(eval($1<10000),1,`eval(20000-$1)',`$1'))')
define(`rand_t',`eval(randSeed^(randSeed>>13))')
define(`random',
   `define(`randSeed',eval((rand_t^(rand_t<<18))&0x7fffffff))randSeed')

define(`set',`define(`$1[$2]',`$3')')
define(`get',`defn(`$1[$2]')')
define(`new',`set($1,size,0)')
define(`append',
   `set($1,size,incr(get($1,size)))`'set($1,get($1,size),$2)')
define(`deck',
   `new($1)for(`x',1,$2,
         `append(`$1',eval(random%$3))')')
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')
define(`show',
   `for(`x',1,get($1,size),`get($1,x) ')')

define(`countingsort',
   `for(`x',$2,$3,`set(count,x,0)')`'for(`x',1,get($1,size),
      `set(count,get($1,x),incr(get(count,get($1,x))))')`'define(`z',
      1)`'for(`x',$2,$3,
         `for(`y',1,get(count,x),
            `set($1,z,x)`'define(`z',incr(z))')')')

divert
deck(`a',10,100)
show(`a')
countingsort(`a',0,99)
show(`a')
