fun f 0 = 1
  | f n = n - m (f (n-1))
and m 0 = 0
  | m n = n - f (m (n-1))
;
