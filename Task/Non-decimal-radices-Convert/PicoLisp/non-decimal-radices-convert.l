(de numToString (N Base)
   (default Base 10)
   (let L NIL
      (loop
         (let C (% N Base)
            (and (> C 9) (inc 'C 39))
            (push 'L (char (+ C `(char "0")))) )
         (T (=0 (setq N (/ N Base)))) )
      (pack L) ) )

(de stringToNum (S Base)
   (default Base 10)
   (let N 0
      (for C (chop S)
         (when (> (setq C (- (char C) `(char "0"))) 9)
            (dec 'C 39) )
         (setq N (+ C (* N Base))) )
      N ) )

(prinl (numToString 26 16))
(prinl (stringToNum "1a" 16))
(prinl (numToString 123456789012345678901234567890 36))
