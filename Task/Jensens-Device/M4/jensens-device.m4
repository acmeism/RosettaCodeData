define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')
define(`sum',
   `pushdef(`temp',0)`'for(`$1',$2,$3,
      `define(`temp',eval(temp+$4))')`'temp`'popdef(`temp')')
sum(`i',1,100,`1000/i')
