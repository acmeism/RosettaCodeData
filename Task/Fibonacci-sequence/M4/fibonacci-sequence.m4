define(`fibo',`ifelse(0,$1,0,`ifelse(1,$1,1,
`eval(fibo(decr($1)) + fibo(decr(decr($1))))')')')dnl
define(`loop',`ifelse($1,$2,,`$3($1) loop(incr($1),$2,`$3')')')dnl
loop(0,15,`fibo')
