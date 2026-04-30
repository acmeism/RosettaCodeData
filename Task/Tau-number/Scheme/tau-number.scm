(define (numdiv n)
  (define (loop k c)
    (if (> k n)
        c
        (loop (+ k 1)
              (if (= (modulo n k) 0)
                  (+ c 1)
                  c))))
  (loop 1 0))

(define (tau? n)
  (= (modulo n (numdiv n)) 0))

(define (print-tau)
  (define (loop i c)
    (cond
      ((= c 100) 'done)
      ((tau? i)
       (begin
         (display i)
         (display " ")
         (when (= (modulo (+ c 1) 10) 0)
           (newline))
         (loop (+ i 1) (+ c 1))))

      (else
       (loop (+ i 1) c))))

  (display "The first 100 tau numbers are:")
  (newline)
  (loop 1 0)
  (newline))

(print-tau)
