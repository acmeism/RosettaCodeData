(de sumDigits (N Base)
   (or
      (=0 N)
      (+ (% N Base) (sumDigits (/ N Base) Base)) ) )
