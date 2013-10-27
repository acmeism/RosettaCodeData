: leap-year? ( y -- ? )
  dup 400 mod 0= if drop true  exit then
  dup 100 mod 0= if drop false exit then
        4 mod 0= ;
