(de levenshtein (A B)
   (let D
      (cons
         (range 0 (length A))
         (mapcar
            '((I) (cons I (copy A)))
            (range 1 (length B)) ) )
      (for (J . Y) B
         (for (I . X) A
            (set
               (nth D (inc J) (inc I))
               (if (= X Y)
                  (get D J I)
                  (inc
                     (min
                        (get D J (inc I))
                        (get D (inc J) I)
                        (get D J I) ) ) ) ) ) ) ) )
