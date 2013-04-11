(let (A 1  B 2)
   (xchg 'A 'B)
   (println A B) )

(let (Lst1 '(a b c)  Lst2 '(d e f))
   (xchg (cdr Lst1) (cdr Lst2))
   (println Lst1 Lst2) )
