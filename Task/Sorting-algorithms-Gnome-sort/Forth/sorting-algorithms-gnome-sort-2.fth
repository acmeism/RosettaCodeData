: gnomesort+                           ( a n)
  swap >r 2 tuck 1-                    ( c2 n c1)
  begin                                ( c2 n c1)
    over over >                        ( c2 n c1 f)
  while                                ( c2 n c1)
    dup if                             ( c2 n c1)
      dup dup 1- over over r@ precedes
      if r@ exchange 1- else drop drop drop >r dup 1+ swap r> swap then
    else drop >r dup 1+ swap r> swap then
  repeat drop drop drop r> drop
;                                      ( --)
