(import srfi/27)

(define (random-permutation n)
  ;; return a vector of the numbers 1 .. n in random order
  (let ((result (list->vector (iota n 1))))
    (do ((i n (- i 1)))
        ((zero? i) result)
      (let* ((index (random-integer i)) ;; in 0 ... i-1
             (temp (vector-ref result index)))
        (vector-set! result index (vector-ref result (- i 1)))
        (vector-set! result (- i 1) temp)))))

(display (random-permutation 20)) (newline)
(display (random-permutation 20)) (newline)
(display (random-permutation 20)) (newline)
(display (random-permutation 20)) (newline)
(display (random-permutation 20)) (newline)
