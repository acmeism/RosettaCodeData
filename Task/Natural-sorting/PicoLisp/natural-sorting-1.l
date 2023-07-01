(de parseNatural (Str)
   (clip
      (make
         (for (L (chop Str)  L)
            (cond
               ((sp? (car L))
                  (link " ")
                  (while (and L (sp? (car L)))
                     (pop 'L) ) )
               ((>= "9" (car L) "0")
                  (link
                     (format
                        (make
                           (loop
                              (link (pop 'L))
                              (NIL (>= "9" (car L) "0")) ) ) ) ) )
               (T
                  (let Word
                     (pack
                        (replace
                           (make
                              (loop
                                 (link (lowc (pop 'L)))
                                 (NIL L)
                                 (T (sp? (car L)))
                                 (T (>= "9" (car L) "0")) ) )
                            "ß" "ss" "ſ" "s" "ʒ" "s" ) )
                     (unless (member Word '(the it to))
                        (link Word) ) ) ) ) ) ) ) )
