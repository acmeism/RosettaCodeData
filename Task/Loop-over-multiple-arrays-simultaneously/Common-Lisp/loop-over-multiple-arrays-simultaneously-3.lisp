(do ((x '("a" "b" "c") (rest x))                       ;
     (y '("A" "B" "C" "D") (rest y))                   ;
     (z '(1 2 3 4 6) (rest z)))	                       ; Initialize lists and set to rest on every loop
    ((or (null x) (null y) (null z)))	               ; Break condition
  (format t "~a~a~a~%" (first x) (first y) (first z))) ; On every loop print first elements
