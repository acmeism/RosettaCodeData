; initialize v to vector of sequential integers
(define (initialize! v)
  (define (iter v n) (if (>= n (vector-length v))
                         (values)
                         (begin (vector-set! v n n) (iter v (+ n 1)))))
  (iter v 0))

; set every nth element of vector v to 0,
; starting with element m
(define (strike! v m n)
  (cond ((>= m (vector-length v)) (values))
        (else (begin
                (vector-set! v m 0)
                (strike! v (+ m n) n)))))

; lowest non-zero index of vector v >= n
(define (nextprime v n)
  (if (zero? (vector-ref v n))
      (nextprime v (+ n 1))
      (vector-ref v n)))

; remove elements satisfying pred? from list lst
(define (remove pred? lst)
  (cond
    ((null? lst) '())
    ((pred? (car lst))(remove pred? (cdr lst)))
    (else (cons (car lst) (remove pred? (cdr lst))))))

; the sieve itself
(define (sieve n)
  (define stop (sqrt n))
  (define (iter v p)
    (cond
      ((> p stop) v)
      (else
       (begin
         (strike! v (* p p) p)
         (iter v (nextprime v (+ p 1)))))))

  (let ((v (make-vector (+ n 1))))
    (initialize! v)
    (vector-set! v 1 0) ; 1 is not a prime
    (remove zero? (vector->list (iter v 2)))))
