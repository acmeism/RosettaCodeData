;;; Fibonacci numbers using Edsger Dijkstra's algorithm
;;; http://www.cs.utexas.edu/users/EWD/ewd06xx/EWD654.PDF

(define (fib n)
  (define (fib-aux a b p q count)
    (cond ((= count 0) b)
          ((even? count)
           (fib-aux a
                    b
                    (+ (* p p) (* q q))
                    (+ (* q q) (* 2 p q))
                    (/ count 2)))
          (else
           (fib-aux (+ (* b q) (* a q) (* a p))
                    (+ (* b p) (* a q))
                    p
                    q
                    (- count 1)))))
  (fib-aux 1 0 0 1 n))
