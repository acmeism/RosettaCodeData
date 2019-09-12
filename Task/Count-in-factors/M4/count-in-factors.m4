define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$5`'popdef(`$1')$0(`$1',eval($2+$4),$3,$4,`$5')')')')dnl
define(`by',
   `ifelse($1,$2,
      $1,
      `ifelse(eval($1%$2==0),1,
         `$2 x by(eval($1/$2),$2)',
         `by($1,eval($2+1))') ') ')dnl
define(`wby',
   `$1 = ifelse($1,1,
      $1,
      `by($1,2)') ')dnl

for(`y',1,25,1, `wby(y)
')
