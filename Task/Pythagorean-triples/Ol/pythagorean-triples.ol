; triples generator based on Euclid's formula, creates lazy list
(define (euclid-formula max)
   (let loop ((a 3) (b 4) (c 5) (tail #null))
      (if (<= (+ a b c) max)
         (cons (tuple a b c) (lambda ()
            (let ((d (- b)) (z (- a)))
            (loop (+ a d d c c) (+ a a d c c) (+ a a d d c c c) (lambda ()
               (loop (+ a b b c c) (+ a a b c c) (+ a a b b c c c) (lambda ()
                  (loop (+ z b b c c) (+ z z b c c) (+ z z b b c c c) tail))))))))
         tail)))

; let's do calculations
(define (calculate max)
   (let loop ((p 0) (t 0) (ll (euclid-formula max)))
      (cond
         ((null? ll)
            (cons p t))
         ((function? ll)
            (loop p t (ll)))
         (else
            (let ((triple (car ll)))
               (loop (+ p 1) (+ t (div max (apply + triple)))
               (cdr ll)))))))

; print values for 10..100000
(for-each (lambda (max)
      (print max ": " (calculate max)))
   (map (lambda (n) (expt 10 n)) (iota 6 1)))
