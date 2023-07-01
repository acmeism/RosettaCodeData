#lang racket
(require math/number-theory)

(define memoised-next-prime
  (let ((m# (make-hash)))
    (λ (P) (hash-ref! m# P (λ () (next-prime P))))))

(define (partition-X-into-N-primes X N)
  (define (partition-x-into-n-primes-starting-at-P x n P result)
    (cond ((= n x 0) result)
          ((or (= n 0) (= x 0) (> P x)) #f)
          (else
           (let ((P′ (memoised-next-prime P)))
             (or (partition-x-into-n-primes-starting-at-P (- x P) (- n 1) P′ (cons P result))
                 (partition-x-into-n-primes-starting-at-P x n P′ result))))))

  (reverse (or (partition-x-into-n-primes-starting-at-P X N 2 null) (list 'no-solution))))

(define (report-partition X N)
  (let ((result (partition-X-into-N-primes X N)))
    (printf "partition ~a\twith ~a\tprimes: ~a~%" X N (string-join (map ~a result) " + "))))

(module+ test
  (report-partition 99809 1)
  (report-partition 18 2)
  (report-partition 19 3)
  (report-partition 20 4)
  (report-partition 2017 24)
  (report-partition 22699 1)
  (report-partition 22699 2)
  (report-partition 22699 3)
  (report-partition 22699 4)
  (report-partition 40355 3))
