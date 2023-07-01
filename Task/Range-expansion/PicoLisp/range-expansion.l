(de rangeexpand (Str)
   (make
      (for S (split (chop Str) ",")
         (if (index "-" (cdr S))
            (chain
               (range
                  (format (head @ S))
                  (format (tail (- -1 @) S)) ) )
            (link (format S)) ) ) ) )
