#lang racket

(define (file-size-distribution (d (current-directory)) #:size-group-function (sgf values))
  (for/fold ((rv (hash)) (Σ 0) (n 0)) ((f (in-directory d)) #:when (file-exists? f))
    (define sz (file-size f))
    (values (hash-update rv (sgf sz) add1 0) (+ Σ sz) (add1 n))))

(define (log10-or-so x) (if (zero? x) #f (round (/ (log x) (log 10)))))

(define number-maybe-<
  (match-lambda** [(#f #f) #f]
                  [(#f _) #t]
                  [(_ #f) #f]
                  [(a b) (< a b)]))

(define ...s? (match-lambda** [(one 1) one] [(one n) (string-append one "s")]))

(define ((report-fsd f) fsd Σ n)
  (for/list ((k (in-list (sort (hash-keys fsd) number-maybe-<))))
    (printf "~a(size): ~a -> ~a ~a~%"
            (object-name f)
            k
            (hash-ref fsd k) (...s? "file" (hash-ref fsd k))))
  (printf "Total: ~a ~a in ~a ~a~%" Σ (...s? "byte" Σ) n (...s? "file" n)))

(module+ test
  (call-with-values (λ () (file-size-distribution #:size-group-function log10-or-so))
                    (report-fsd log10-or-so)))
