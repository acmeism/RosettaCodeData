(de *Items
   ("map" 9 150)                    ("compass" 13 35)
   ("water" 153 200)                ("sandwich" 50 160)
   ("glucose" 15 60)                ("tin" 68 45)
   ("banana" 27 60)                 ("apple" 39 40)
   ("cheese" 23 30)                 ("beer" 52 10)
   ("suntan cream" 11 70)           ("camera" 32 30)
   ("t-shirt" 24 15)                ("trousers" 48 10)
   ("umbrella" 73 40)               ("waterproof trousers" 42 70)
   ("waterproof overclothes" 43 75) ("note-case" 22 80)
   ("sunglasses" 7 20)              ("towel" 18 12)
   ("socks" 4 50)                   ("book" 30 10) )

# Dynamic programming solution
(de knapsack (Lst W)
   (when Lst
      (cache '*KnapCache (pack (length Lst) ":" W)
         (let X (knapsack (cdr Lst) W)
            (if (ge0 (- W (cadar Lst)))
               (let Y (cons (car Lst) (knapsack (cdr Lst) @))
                  (if (> (sum caddr X) (sum caddr Y)) X Y) )
               X ) ) ) ) )

(let K (knapsack *Items 400)
   (for I K
      (apply tab I (3 -24 6 6) NIL) )
   (tab (27 6 6) NIL (sum cadr K) (sum caddr K)) )
