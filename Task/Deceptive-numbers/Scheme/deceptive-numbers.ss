(define prime?
   (let ((wheel '(1 2 2 . #1=(4 2 4 2 4 6 2 6 . #1#))))
      (lambda (n)
         (if (< n 2)
            #f
            (let loop ((f 2) (w wheel))
               (cond
                  ((> (* f f) n)  #t)
                  ((zero? (remainder n f))  #f)
                  (#t  (loop (+ f (car w)) (cdr w)))))))))

(define (deceptives n)
   (let loop ((k 2) (r 1) (n n) (l '()))
      (if (zero? n)
         (reverse! l)
         (if (and (not (prime? k)) (zero? (remainder r k)))
            (loop (+ k 1) (+ (* 10 r) 1) (- n 1) (cons k l))
            (loop (+ k 1) (+ (* 10 r) 1) n l)))))
