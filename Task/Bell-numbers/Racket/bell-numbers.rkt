#lang racket

(define (build-bell-row previous-row)
  (define seed (last previous-row))
  (reverse
   (let-values (((reversed _) (for/fold ((acc (list seed)) (prev seed))
                                        ((pprev previous-row))
                                (let ((n (+ prev pprev))) (values (cons n acc) n)))))
     reversed)))

(define reverse-bell-triangle
  (let ((memo (make-hash '((0 . ((1)))))))
    (λ (rows) (hash-ref! memo
                         rows
                         (λ ()
                           (let ((prev (reverse-bell-triangle (sub1 rows))))
                             (cons (build-bell-row (car prev)) prev)))))))

(define bell-triangle (compose reverse reverse-bell-triangle))

(define bell-number (compose caar reverse-bell-triangle))

(module+ main
  (map bell-number (range 15))
  (bell-number 50)
  (bell-triangle 10))
