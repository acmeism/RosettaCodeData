(define (addN n)
   (lambda (x) (+ x n)))

(let ((add10 (addN 10))
      (add20 (addN 20)))
   (print "(add10 4) ==> " (add10 4))
   (print "(add20 4) ==> " (add20 4)))
