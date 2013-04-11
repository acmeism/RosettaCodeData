(de partitions (Args)
   (let Lst (range 1 (apply + Args))
      (recur (Args Lst)
         (ifn Args
            '(NIL)
            (mapcan
               '((L)
                  (mapcar
                     '((R) (cons L R))
                     (recurse (cdr Args) (diff Lst L)) ) )
               (comb (car Args) Lst) ) ) ) ) )
