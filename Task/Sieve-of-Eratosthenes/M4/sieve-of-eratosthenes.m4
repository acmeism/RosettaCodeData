define(`lim',100)dnl
define(`for',
   `ifelse($#,0,
      ``$0'',
      `ifelse(eval($2<=$3),1,
         `pushdef(`$1',$2)$5`'popdef(`$1')$0(`$1',eval($2+$4),$3,$4,`$5')')')')dnl
for(`j',2,lim,1,
   `ifdef(a[j],
      `',
      `j for(`k',eval(j*j),lim,j,
         `define(a[k],1)')')')
