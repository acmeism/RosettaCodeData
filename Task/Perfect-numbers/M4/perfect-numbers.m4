define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')dnl

define(`ispart',
   `ifelse(eval($2*$2<=$1),1,
      `ifelse(eval($1%$2==0),1,
         `ifelse(eval($2*$2==$1),1,
            `ispart($1,incr($2),eval($3+$2))',
            `ispart($1,incr($2),eval($3+$2+$1/$2))')',
         `ispart($1,incr($2),$3)')',
      $3)')
define(`isperfect',
   `eval(ispart($1,2,1)==$1)')

for(`x',`2',`33550336',
   `ifelse(isperfect(x),1,`x
')')
