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
dnl  for the heap calculations, it's easier if origin is 0, so set value first
define(`append',
   `set($1,size,incr(get($1,size)))`'set($1,get($1,size),$2)')

dnl  swap(<name>,<j>,<name>[<j>],<k>)  using arg stack for the temporary
define(`swap',`set($1,$2,get($1,$4))`'set($1,$4,$3)')

define(`deck',
   `new($1)for(`x',1,$2,
         `append(`$1',eval(random%100))')')
define(`show',
   `for(`x',1,get($1,size),`get($1,x) ')')
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')

define(`bubbleonce',
   `for(`x',1,$2,
      `ifelse(eval(get($1,x)>get($1,incr(x))),1,
         `swap($1,x,get($1,x),incr(x))`'1')')0')
define(`bubbleupto',
   `ifelse(bubbleonce($1,$2),0,
      `',
      `bubbleupto($1,decr($2))')')
define(`bubblesort',
   `bubbleupto($1,decr(get($1,size)))')

divert
deck(`a',10)
show(`a')
bubblesort(`a')
show(`a')
