(de fdiff (Lst)
   (mapcar - (cdr Lst) Lst) )

(for (L (90 47 58 29 22 32 55 5 55 73) L (fdiff L))
   (println L) )
