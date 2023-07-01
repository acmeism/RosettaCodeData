(de sedol (Str)
   (pack Str
      (char
         (+ `(char "0")
            (%
               (- 10
                  (%
                     (sum
                        '((W C)
                           (cond
                              ((>= "9" C "0")
                                 (* W (format C)) )
                              ((>= "Z" (setq C (uppc C)) "A")
                                 (* W (+ 10 (- (char C) `(char "A")))) ) ) )
                        (1 3 1 7 3 9)
                        (chop Str) )
                     10 ) )
               10 ) ) ) ) )

(for S '("710889" "B0YBKJ" "406566" "B0YBLH" "228276" "B0YBKL" "557910" "B0YBKR" "585284" "B0YBKT" "B00030")
   (prinl (sedol S)) )
