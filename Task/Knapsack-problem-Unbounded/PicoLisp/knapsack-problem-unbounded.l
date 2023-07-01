(de *Items
   ("panacea"  3  25  3000)
   ("ichor"    2  15  1800)
   ("gold"    20   2  2500) )

(de knapsack (Lst W V)
   (when Lst
      (let X (knapsack (cdr Lst) W V)
         (if (and (ge0 (dec 'W (cadar Lst))) (ge0 (dec 'V (caddar Lst))))
            (maxi
               '((L) (sum cadddr L))
               (list
                  X
                  (cons (car Lst) (knapsack (cdr Lst) W V))
                  (cons (car Lst) (knapsack Lst W V)) ) )
            X ) ) ) )

(let K (knapsack *Items 250 250)
   (for (L K  L)
      (let (N 1  X)
         (while (= (setq X (pop 'L)) (car L))
            (inc 'N) )
         (apply tab X (4 2 8 5 5 7) N "x") ) )
   (tab (14 5 5 7) NIL (sum cadr K) (sum caddr K) (sum cadddr K)) )
