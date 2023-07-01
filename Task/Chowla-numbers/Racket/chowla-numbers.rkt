#lang racket

(require racket/fixnum)

(define cache-size 35000000)

(define chowla-cache (make-fxvector cache-size -1))

(define (chowla/uncached n)
  (for/sum ((i (sequence-filter (λ (x) (zero? (modulo n x))) (in-range 2 (add1 (quotient n 2)))))) i))

(define (chowla n)
  (if (> n cache-size)
    (chowla/uncached n)
    (let ((idx (sub1 n)))
      (if (negative? (fxvector-ref chowla-cache idx))
        (let ((c (chowla/uncached n))) (fxvector-set! chowla-cache idx c) c)
        (fxvector-ref chowla-cache idx)))))

(define (prime?/chowla n)
  (and (> n 1)
       (zero? (chowla n))))

(define (perfect?/chowla n)
  (and (> n 1)
       (= n (add1 (chowla n)))))

(define (make-chowla-sieve n)
  (let ((v (make-vector n 0)))
    (for* ((i (in-range 2 n)) (j (in-range (* 2 i) n i))) (vector-set! v j (+ i (vector-ref v j))))
    (for ((i (in-range 1 n))) (fxvector-set! chowla-cache (sub1 i) (vector-ref v i)))))

(module+
  main
  (define (count-and-report-primes limit)
    (printf "Primes < ~a: ~a~%" limit (for/sum ((i (sequence-filter prime?/chowla (in-range 2 (add1 limit))))) 1)))

  (for ((i (in-range 1 (add1 37)))) (printf "(chowla ~a) = ~a~%" i (chowla i)))

  (make-chowla-sieve cache-size)

  (for-each count-and-report-primes '(1000 10000 100000 1000000 10000000))

  (let ((ns (for/list ((n (sequence-filter perfect?/chowla (in-range 2 35000000)))) n)))
    (printf "There are ~a perfect numbers <= 35000000: ~a~%" (length ns) ns)))
