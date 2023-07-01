(let Sizes NIL                         # Build a list of sizes
   (let Lines                          # and of lines
      (make
         (in "input.txt"                     # Reading input file
            (while (split (line) "$")        # delimited by '$'
               (let (L (link (mapcar pack @))  S Sizes)
                  (setq Sizes                   # Maintain sizes
                     (make
                        (while (or L S)
                           (link
                              (max
                                 (inc (length (pop 'L)))
                                 (pop 'S) ) ) ) ) ) ) ) ) )
      (for L Lines                                 # Print lines
         (prinl (apply align L (mapcar - Sizes))) )   # left aligned
      (prinl)
      (for L Lines
         (prinl (apply align L Sizes)) )              # right aligned
      (prinl)
      (for L Lines
         (prinl (apply center L Sizes)) ) ) )         # and centered
