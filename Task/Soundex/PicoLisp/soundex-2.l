(de soundex (Str)
   (let (Str (chop Str) Last)
      (pack
         (pad
            -4
            (cons
               (uppc (car Str))
               (head
                  3
                  (filter
                     gt0
                     (cdr
                        (mapcar
                           '((C)
                              (and
                                 (setq C
                                    (case (uppc C)
                                       (`(chop "AEIOUY") 0)
                                       (`(chop "BFPV") 1)
                                       (`(chop "CGJKQSXZ") 2)
                                       (("D" "T") 3)
                                       ("L" 4)
                                       (("M" "N") 5)
                                       ("R" 6) ) )
                                 (<> Last C)
                                 (setq Last C) ) )
                           Str ) ) ) ) ) ) ) ) )
