; simple version
(define (A m n)
    (cond
        ((= m 0) (+ n 1))
        ((= n 0) (A (- m 1) 1))
        (else (A (- m 1) (A m (- n 1))))))

(print "simple version (A 3 6): " (A 3 6))

; smart (lazy) version
(define (ints-from n)
   (cons* n (delay (ints-from (+ n 1)))))

(define (knuth-up-arrow a n b)
  (let loop ((n n) (b b))
    (cond ((= b 0) 1)
          ((= n 1) (expt a b))
          (else    (loop (- n 1) (loop n (- b 1)))))))

(define (A+ m n)
   (define (A-stream)
      (cons*
         (ints-from 1) ;; m = 0
         (ints-from 2) ;; m = 1
         ;; m = 2
         (lmap (lambda (n)
                  (+ (* 2 (+ n 1)) 1))
            (ints-from 0))
         ;; m = 3
         (lmap (lambda (n)
               (- (knuth-up-arrow 2 (- m 2) (+ n 3)) 3))
            (ints-from 0))
         ;; m = 4...
         (delay (ldrop (A-stream) 3))))
   (llref (llref (A-stream) m) n))

(print "extended version (A 3 6): " (A+ 3 6))
