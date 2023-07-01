(define (invsq f to)
  (let loop ((f f) (s 0))
    (if (> f to)
      s
      (loop (+ 1 f) (+ s (/ 1 f f))))))

;; whether you get a rational or a float depends on implementation
(invsq 1 1000) ; 835459384831...766449/50820...90400000000
(exact->inexact (invsq 1 1000)) ; 1.64393456668156
