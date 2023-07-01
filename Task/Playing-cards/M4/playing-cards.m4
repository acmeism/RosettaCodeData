define(`randSeed',141592653)dnl
define(`setRand',
   `define(`randSeed',ifelse(eval($1<10000),1,`eval(20000-$1)',`$1'))')dnl
define(`rand_t',`eval(randSeed^(randSeed>>13))')dnl
define(`random',
   `define(`randSeed',eval((rand_t^(rand_t<<18))&0x7fffffff))randSeed')dnl
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')dnl
define(`foreach', `pushdef(`$1')_foreach($@)popdef(`$1')')dnl
define(`_arg1', `$1')dnl
define(`_foreach', `ifelse(`$2', `()', `',
   `define(`$1', _arg1$2)$3`'$0(`$1', (shift$2), `$3')')')dnl
define(`new',`define(`$1[size]',0)')dnl
define(`append',
   `define(`$1[size]',incr(defn(`$1[size]')))`'define($1[defn($1[size])],$2)')
define(`deck',
   `new($1)foreach(`x',(Ace,2,3,4,5,6,7,8,9,10,Jack,Queen,King),
      `foreach(`y',(Clubs,Diamonds,Hearts,Spades),
         `append(`$1',`x of y')')')')dnl
define(`show',
   `for(`x',1,defn($1[size]),`defn($1[x])ifelse(x,defn($1[size]),`',`, ')')')dnl
define(`swap',`define($1[$2],defn($1[$4]))define($1[$4],$3)')dnl
define(`shuffle',
   `for(`x',1,defn($1[size]),
      `swap($1,x,defn($1[x]),eval(1+random%defn($1[size])))')')dnl
define(`deal',
   `ifelse($#,0,``$0'',
   `ifelse(defn($1[size]),0,
      `NULL',
      defn($1[defn($1[size])])define($1[size],decr(defn($1[size]))))')')dnl
dnl
deck(`b')
show(`b')
shuffling shuffle(`b')
show(`b')
deal deal(`b')
deal deal(`b')
show(`b')
