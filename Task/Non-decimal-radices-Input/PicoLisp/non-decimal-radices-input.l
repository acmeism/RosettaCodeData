(de parseNumber (S Base)
   (let N 0
      (for C (chop S)
         (when (> (setq C (- (char C) `(char "0"))) 9)
            (dec 'C 39) )
         (setq N (+ C (* N Base))) )
      N ) )

(println (parseNumber "91g5dcg2h6da7260a9f3c4a" 19))
