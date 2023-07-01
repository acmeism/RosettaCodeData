(define mapi
  _ _ []       -> []
  F N [X | Xs] -> [(F N X) | (mapi F (+ N 1) Xs)])

(define double
  X -> (let Y (* 2 X) (if (> Y 9) (- Y 9) Y)))

(define luhn?
  Number ->
    (let Exploded (explode Number)
         Digits   (map (/. H (- (string->n H) 48)) Exploded)
         Reversed (reverse Digits)
         Doubled  (mapi (/. N X (if (= 1 (shen.mod N 2)) (double X) X)) 0 Reversed)
         Summed   (sum Doubled)
         Modded   (shen.mod Summed 10)
      (= 0 Modded)))

"Expected: [true false false true]"

(map (function luhn?) ["49927398716" "49927398717" "1234567812345678" "1234567812345670"])
