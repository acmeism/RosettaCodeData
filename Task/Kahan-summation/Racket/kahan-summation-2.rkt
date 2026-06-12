(define epsilon.f0
  (let loop ([epsilon 1.f0])
    (if (= (+ 1.f0 epsilon) 1.f0)
        epsilon
        (loop (/ epsilon 2.f0)))))

(displayln "Alternative task, single precision flonum")
epsilon.f0

(+ 1.f0 epsilon.f0 (- epsilon.f0))
(sum/kahan 1.f0 epsilon.f0 (- epsilon.f0))
