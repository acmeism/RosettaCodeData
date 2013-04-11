(de *Items
   ("map" 9 150 1)                     ("compass" 13 35 1)
   ("water" 153 200 3)                 ("sandwich" 50 60 2)
   ("glucose" 15 60 2)                 ("tin" 68 45 3)
   ("banana" 27 60 3)                  ("apple" 39 40 3)
   ("cheese" 23 30 1)                  ("beer" 52 10 3)
   ("suntan cream" 11 70 1)            ("camera" 32 30 1)
   ("t-shirt" 24 15 2)                 ("trousers" 48 10 2)
   ("umbrella" 73 40 1)                ("waterproof trousers" 42 70 1)
   ("waterproof overclothes" 43 75 1)  ("note-case" 22 80 1)
   ("sunglasses" 7 20 1)               ("towel" 18 12 2)
   ("socks" 4 50 1)                    ("book" 30 10 2) )

# Dynamic programming solution
(de knapsack (Lst W)
   (when Lst
      (cache '*KnapCache (pack (length Lst) ":" W)
         (let X (knapsack (cdr Lst) W)
            (if (ge0 (- W (cadar Lst)))
               (let Y (cons (car Lst) (knapsack (cdr Lst) @))
                  (if (> (sum caddr X) (sum caddr Y)) X Y) )
               X ) ) ) ) )

(let K
   (knapsack
      (mapcan                                   # Expand multiple items
         '((X) (need (cadddr X) NIL X))
         *Items )
      400 )
   (for I K
      (apply tab I (3 -24 6 6) NIL) )
   (tab (27 6 6) NIL (sum cadr K) (sum caddr K)) )
