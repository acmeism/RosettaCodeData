(define (do _ranges _func)
  (apply
    (fn (_ a b c) (for (_i a b c) (_func _i)))
    (cons nil _ranges)
    4))

(let (prod 1   sum  0
      x 5
      y -5
      z -2
      one 1  three 3  seven 7)
  (do (list
         (- three) (pow 3 3) three
         (- seven) seven x
         555 (- 550  y) 1
         22  -28 (- three)
         1927 1939 1
         x y z
         (pow 11 x) (+ (pow 11 x) one) 1)
    (fn (j)
      (++ sum (abs j))
      (and (< (abs prod) (pow 2 27)) (not (zero? j))
        (setq prod (* prod j)))))
  (println "sum: " sum  "   product: " prod))

sum: 348173   product: -793618560
