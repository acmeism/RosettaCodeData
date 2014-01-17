(de middle3digits (N)
   (let (Lst (chop (abs N))  Len (length Lst))
      (tab (10 -2 -30)
         N
         ":"
         (cond
            ((> 3 Len) "not enough digits")
            ((bit? 1 Len)
               (head 3 (nth Lst (/ Len 2))) )
            (T "even number of digits") ) ) ) )
