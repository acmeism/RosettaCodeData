define(`power',`ifelse($2,0,1,`eval($1*$0($1,decr($2)))')')
power(2,10)
