(setq Lst
   (make
      (for Y (range 1900 2100)
         (for M (range 1 12)
            (and
               (date Y M 31)
               (= "Friday" (day (date Y M 1)))
               (link (list (get *Mon M) Y)) ) ) ) ) )

(prinl "There are " (length Lst) " months with five weekends:")
(mapc println (head 5 Lst))
(prinl "...")
(mapc println (tail 5 Lst))
(prinl)
(setq Lst (diff (range 1900 2100) (uniq (mapcar cadr Lst))))
(prinl "There are " (length Lst) " years with no five-weekend months:")
(println Lst)
