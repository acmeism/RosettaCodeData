#lang racket

(define (cdr-empty ls) (if (empty? ls) empty (cdr ls)))

(define (names-of n)
  (define (names-of-tail ans raws-rest n)
    (if (zero? n)
        ans
        (names-of-tail (cons 1 (append (map +
                                            (take ans (length raws-rest))
                                            (map car raws-rest))
                                       (drop ans (length raws-rest))))
                       (filter (compose not empty?)
                               (map cdr-empty (cons ans raws-rest)))
                       (sub1 n))))
  (names-of-tail '() '() n))

(define (G n) (foldl + 0 (names-of n)))

(module+ main
  (build-list 25 (compose names-of add1))
  (newline)
  (map G '(23 123 1234)))
