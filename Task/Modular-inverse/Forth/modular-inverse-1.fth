: invmod { a m | v b c -- inv }
  m to v
  1 to c
  0 to b
  begin a
  while v a / >r
     c b s>d c s>d r@ 1 m*/ d- d>s to c to b
     a v s>d a s>d r> 1 m*/ d- d>s to a to v
  repeat b m mod dup to b 0<
  if m b + else b then ;
