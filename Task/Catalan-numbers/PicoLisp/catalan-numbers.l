# Factorial
(de fact (N)
   (if (=0 N)
      1
      (* N (fact (dec N))) ) )

# Directly
(de catalanDir (N)
   (/ (fact (* 2 N)) (fact (inc N)) (fact N)) )

# Recursively
(de catalanRec (N)
   (if (=0 N)
      1
      (cache '(NIL) (pack (char (hash N)) N)  # Memoize
         (sum
            '((I) (* (catalanRec I) (catalanRec (- N I 1))))
            (range 0 (dec N)) ) ) ) )

# Alternatively
(de catalanAlt (N)
   (if (=0 N)
      1
      (*/ 2 (dec (* 2 N)) (catalanAlt (dec N)) (inc N)) ) )

# Test
(for (N 0 (> 15 N) (inc N))
   (tab (2 4 8 8 8)
      N
      " => "
      (catalanDir N)
      (catalanRec N)
      (catalanAlt N) ) )
