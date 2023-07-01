define(`testnext',
   `ifelse(eval($2*$2>$1),1,
      1,
      `ifelse(eval($1%$2==0),1,
         0,
         `testnext($1,eval($2+2))')')')
define(`isprime',
   `ifelse($1,2,
      1,
      `ifelse(eval($1<=1 || $1%2==0),1,
         0,
         `testnext($1,3)')')')

isprime(9)
isprime(11)
