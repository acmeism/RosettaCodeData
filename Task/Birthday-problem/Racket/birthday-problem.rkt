#lang racket

#;(define repetitions 25000000) ; for \sigma=1/10000
(define repetitions 250000) ; for \sigma=1/1000
(define coarse-repetitions 2500)

(define (vector-inc! v pos)
  (vector-set! v pos (add1 (vector-ref v pos))))

(define (equal-birthdays sharers group-size repetitions)
  (/ (for/sum ([j (in-range repetitions)])
        (let ([days (make-vector 365 0)])
          (for ([person (in-range group-size)])
            (vector-inc! days (random 365)))
          (if (>= (apply max (vector->list days)) sharers)
              1 0)))
      repetitions))

(define (search-coarse-group-size sharers)
  (let loop ([coarse-group-size 2])
    (let ([coarse-probability
          (equal-birthdays sharers coarse-group-size coarse-repetitions)])
      (if (> coarse-probability .5)
          coarse-group-size
          (loop (add1 coarse-group-size))))))

(define (search-upwards sharers group-size)
  (let ([probability (equal-birthdays sharers group-size repetitions)])
    (if (> probability .5)
        (values group-size probability)
        (search-upwards sharers (add1 group-size)))))

(define (search-downwards sharers group-size last-probability)
  (let ([probability (equal-birthdays sharers group-size repetitions)])
    (if (> probability .5)
        (search-downwards sharers (sub1 group-size) probability)
        (values (add1 group-size) last-probability))))

(define (search-from sharers group-size)
  (let ([probability (equal-birthdays sharers group-size repetitions)])
    (if (> probability .5)
        (search-downwards sharers (sub1 group-size) probability)
        (search-upwards sharers (add1 group-size)))))

(for ([sharers (in-range 2 6)])
  (let-values ([(group-size probability)
                (search-from sharers (search-coarse-group-size sharers))])
    (printf "~a independent people in a group of ~a share a common birthday. (~a%)\n"
            sharers group-size  (~r (* probability 100) #:precision '(= 2)))))
