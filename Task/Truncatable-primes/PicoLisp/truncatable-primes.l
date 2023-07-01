(load "@lib/rsa.l")  # Use the 'prime?' function from RSA package

(de truncatablePrime? (N Fun)
   (for (L (chop N) L (Fun L))
      (T (= "0" (car L)))
      (NIL (prime? (format L)))
      T ) )

(let (Left 1000000  Right 1000000)
   (until (truncatablePrime? (dec 'Left) cdr))
   (until (truncatablePrime? (dec 'Right) '((L) (cdr (rot L)))))
   (cons Left Right) )
