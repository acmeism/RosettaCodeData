(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (modulo a b))))
