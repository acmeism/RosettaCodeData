: curry ( x xt1 -- xt2 )
  swap 2>r :noname r> postpone literal r> compile, postpone ; ;

5 ' + curry constant +5
5 +5 execute .
7 +5 execute .
