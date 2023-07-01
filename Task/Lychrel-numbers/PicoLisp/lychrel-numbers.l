(de pali? (N)
   (let N (chop N)
      (= N (reverse N)) ) )
(de lychrel (A)
   (let
      (R NIL
         Lst
         (make
            (for X A
               (let (N X  C 500)
                  (while
                     (and
                        (inc 'N (format (flip (chop N))))
                        (gt0 (dec 'C))
                        (not (pali? N)) ) )
                  (and (=0 C) (link X) ) ) ) )
         Lst22
         (by
            '((N)
               (let (X N  C 3)
                  (prog1
                     (bool
                        (or
                           (member (+ N (format (flip (chop N)))) R)
                           (find
                              '((N) (member N R))
                              (make
                                 (do C
                                    (link (inc 'X (format (flip (chop X))))) ) ) ) ) )
                  (do C
                     (push1
                        'R
                        (inc 'N (format (flip (chop N)))) ) ) ) ) )
            group
            Lst )
         P (filter pali? Lst) )
      (prinl
         "Using n = 1..10000 and limiting each search to 500 reverse-digits-and-adds" )
      (prinl
         "  Number of Lychrel numbers: "
         (length (car Lst22)) )
      (prin "    Lychrel numbers: ")
      (println (car Lst22))
      (prinl
         "  Number of Lychrel related: "
         (length (cadr Lst22)) )
      (prinl
         "  Number of Lychrel palindroms: "
         (length P) )
      (prin "    Lychrel palindromes: ")
      (println P) ) )

(lychrel 10000)

(bye)
