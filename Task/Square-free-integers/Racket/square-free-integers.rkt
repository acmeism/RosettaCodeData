#lang racket

(define (not-square-free-set-for-range range-min (range-max (add1 range-min)))
  (for*/set ((i2 (sequence-map sqr (in-range 2 (add1 (integer-sqrt range-max)))))
             (i2.x (in-range (* i2 (quotient range-min i2))
                             (* i2 (add1 (quotient range-max i2)))
                             i2))
             #:when (and (<= range-min i2.x)
                         (< i2.x range-max)))
    i2.x))

(define (square-free? n #:table (table (not-square-free-set-for-range n)))
  (not (set-member? table n)))

(define (count-square-free-numbers #:range-min (range-min 1) range-max)
  (- range-max range-min (set-count (not-square-free-set-for-range range-min range-max))))

(define ((print-list-to-width w) l)
  (let loop ((l l) (x 0))
    (if (null? l)
        (unless (zero? x) (newline))
        (let* ((str (~a (car l))) (len (string-length str)))
          (cond [(<= (+ len x) w) (display str) (write-char #\space) (loop (cdr l) (+ x len 1))]
                [(zero? x) (displayln str) (loop (cdr l) 0)]
                [else (newline) (loop l 0)])))))


(define print-list-to-80 (print-list-to-width 80))

(module+ main
  (print-list-to-80 (for/list ((n (in-range 1 (add1 145))) #:when (square-free? n)) n))

  (print-list-to-80 (time (let ((table (not-square-free-set-for-range #e1e12 (add1 (+ #e1e12 145)))))
                            (for/list ((n (in-range #e1e12 (add1 (+ #e1e12 145))))
                                       #:when (square-free? n #:table table)) n))))
  (displayln "Compare time taken without the table (rather with table on the fly):")
  (void (time (for/list ((n (in-range #e1e12 (add1 (+ #e1e12 145)))) #:when (square-free? n)) n)))

  (count-square-free-numbers 100)
  (count-square-free-numbers 1000)
  (count-square-free-numbers 10000)
  (count-square-free-numbers 100000)
  (count-square-free-numbers 1000000))
