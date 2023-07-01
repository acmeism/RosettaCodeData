divert(-1)
define(`set',`define(`$1[$2]',`$3')')
define(`get',`defn(`$1[$2]')')
define(`setrange',`ifelse(`$3',`',$2,`define($1[$2],$3)`'setrange($1,
   incr($2),shift(shift(shift($@))))')')
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')
define(`show',
   `for(`k',0,decr($1),`get(a,k) ')')

define(`chklim',
   `ifelse(get(`a',$3),eval($2-($1-$3)),
      `chklim($1,$2,decr($3))',
      `set(`a',$3,incr(get(`a',$3)))`'for(`k',incr($3),decr($2),
         `set(`a',k,incr(get(`a',decr(k))))')`'nextcomb($1,$2)')')
define(`nextcomb',
   `show($1)
ifelse(eval(get(`a',0)<$2-$1),1,
      `chklim($1,$2,decr($1))')')
define(`comb',
   `for(`j',0,decr($1),`set(`a',j,j)')`'nextcomb($1,$2)')
divert

comb(3,5)
