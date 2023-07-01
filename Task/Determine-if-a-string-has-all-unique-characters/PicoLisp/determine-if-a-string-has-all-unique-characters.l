(de burn (Lst)
   (let P 0
      (by
         '((A)
            (set A (inc 'P))
            (put A 'P (char A)) )
         group
         Lst ) ) )
(de first (Lst)
   (mini
      '((L)
         (nand
            (cdr L)
            (apply min (mapcar val L)) ) )
      Lst ) )
(de uniq? (Str)
   (let M (first (burn (chop Str)))
      (ifn M
         (prinl Str " (length " (length Str) "): all characters are unique")
         (prin
            Str " (length " (length Str) "): first duplicate character "
            (car M)
            " at positions " )
         (println (mapcar val M)) ) ) )
(uniq?)
(uniq? ".")
(uniq? "abcABC")
(uniq? "XYZ ZYX")
(uniq? "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ")
