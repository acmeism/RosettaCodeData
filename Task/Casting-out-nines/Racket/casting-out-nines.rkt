#lang racket
(require math)

(define (digits n)
  (map (compose1 string->number string)
       (string->list (number->string n))))

(define (cast-out-nines n)
  (with-modulus 9
    (for/fold ([sum 0]) ([d (digits n)])
      (mod+ sum d))))
