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
   `set($1,get($1,size),$2)`'set($1,size,incr(get($1,size)))')

dnl  swap(<name>,<j>,<name>[<j>],<k>)  using arg stack for the temporary
define(`swap',`set($1,$2,get($1,$4))`'set($1,$4,$3)')

define(`deck',
   `new($1)for(`x',1,$2,
         `append(`$1',eval(random%100))')')
define(`show',
   `for(`x',0,decr(get($1,size)),`get($1,x) ')')
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')

define(`ifywork',
   `ifelse(eval($2>=0),1,
      `siftdown($1,$2,$3)`'ifywork($1,decr($2),$3)')')
define(`heapify',
   `define(`start',eval((get($1,size)-2)/2))`'ifywork($1,start,
      decr(get($1,size)))')
define(`siftdown',
   `define(`child',eval($2*2+1))`'ifelse(eval(child<=$3),1,
       `ifelse(eval(child+1<=$3),1,
       `ifelse(eval(get($1,child)<get($1,incr(child))),1,
       `define(`child',
           incr(child))')')`'ifelse(eval(get($1,$2)<get($1,child)),1,
       `swap($1,$2,get($1,$2),child)`'siftdown($1,child,$3)')')')
define(`sortwork',
   `ifelse($2,0,
      `',
      `swap($1,0,get($1,0),$2)`'siftdown($1,0,decr($2))`'sortwork($1,
            decr($2))')')

define(`heapsort',
   `heapify($1)`'sortwork($1,decr(get($1,size)))')

divert
deck(`a',10)
show(`a')
heapsort(`a')
show(`a')
