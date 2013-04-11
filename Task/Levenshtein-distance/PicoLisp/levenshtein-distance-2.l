(de levenshtein (A B)
   (let D
      (cons
         (range 0 (length A))
         (mapcar
            '((I) (cons I (copy A)))
            (range 1 (length B)) ) )
      (map
         '((B Y)
            (map
               '((A X P)
                  (set (cdr P)
                     (if (= (car A) (car B))
                        (car X)
                        (inc (min (cadr X) (car P) (car X))) ) ) )
               A
               (car Y)
               (cadr Y) ) )
         B
         D ) ) )
