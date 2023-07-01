(for N (627615 39390 588225 393900588225)
   (for ((A . I) N  T  (sum format (chop I)))
      (T (> 10 I)
         (prinl N " has additive persistance " (dec A) " and digital root of " I ";") ) ) )
