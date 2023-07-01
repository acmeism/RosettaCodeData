(import (scheme base)
        (scheme write))

(define (loop-fn start end)
  (define (loop i)
    (if (> i end) #f
        (begin
         (display i)
         (cond ((zero? (modulo i 5))
                (newline) (loop (+ 1 i)))
               (else
                (display ", ")
                (loop (+ 1 i)))))))
  (loop start))

(loop-fn 1 10)
