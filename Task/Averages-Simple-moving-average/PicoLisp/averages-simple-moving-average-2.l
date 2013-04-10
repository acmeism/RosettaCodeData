(def 'sma3 (sma 3))
(def 'sma5 (sma 5))

(scl 2)
(for N (1.0 2.0 3.0 4.0 5.0 5.0 4.0 3.0 2.0 1.0)
   (prinl
      (format N *Scl)
      "   (sma3) "
      (format (sma3 N) *Scl)
      "   (sma5) "
      (format (sma5 N) *Scl) ) )
