(use srfi-42)

(define (py perim)
  (define prim 0)
  (values
    (sum-ec
      (: c perim) (: b c) (: a b)
      (if (and (<= (+ a b c) perim)
               (= (square c) (+ (square b) (square a)))))
      (begin (when (= 1 (gcd a b)) (inc! prim)))
      1)
    prim))
