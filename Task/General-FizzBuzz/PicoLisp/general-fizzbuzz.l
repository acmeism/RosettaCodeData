(de general (N Lst)
   (for A N
      (prinl
         (or
            (extract
               '((L)
                  (and (=0 (% A (car L))) (cdr L)) )
               Lst )
            A ) ) ) )

(general 20 '((3 . Fizz) (5 . Buzz) (7 . Baxx)))
