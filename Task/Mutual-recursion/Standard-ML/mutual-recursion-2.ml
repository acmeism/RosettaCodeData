val rec f = fn 0 => 1
             | n => n - m (f (n-1))
and m = fn 0 => 0
         | n => n - f (m (n-1))
;
