: f**n ( f n -- f^n )
  dup 0= if
    drop fdrop 1e
  else dup 1 and if
    1- fdup recurse f*
  else
    2/ fdup f* recurse
  then then ;
