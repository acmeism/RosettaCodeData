: A {: w^ k x1 x2 x3 xt: x4 xt: x5 | w^ B :} recursive
  k @ 0<= IF  x4 x5 f+  ELSE
    B k x1 x2 x3 action-of x4 [{: B k x1 x2 x3 x4 :}L
      -1 k +!
      k @ B @ x1 x2 x3 x4 A ;] dup B !
      execute  THEN ;
10 [: 1e ;] [: -1e ;] 2dup swap [: 0e ;] A f.
