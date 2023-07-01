define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$5`'popdef(`$1')$0(`$1',eval($2+$4),$3,$4,`$5')')')')

for(`x',1,100,1,
   `ifelse(eval(x%15==0),1,FizzBuzz,
   `ifelse(eval(x%3==0),1,Fizz,
   `ifelse(eval(x%5==0),1,Buzz,x)')')
')
