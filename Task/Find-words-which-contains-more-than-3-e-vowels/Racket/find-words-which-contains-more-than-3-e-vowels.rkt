#lang racket

;; probably not the best name, but matches the name of the task
(define (contains-more-than-3-e-vowels? s)
  (let loop ((i (string-length s)) (es 0))
    (if (zero? i)
        (> es 3)
        (let ((i- (sub1 i)))
          (match (string-ref s i-)
            ((or #\a #\i #\o #\u) #f)
            (#\e (loop i- (add1 es)))
            (_ (loop i- es)))))))

(define qualifying-words
  (filter contains-more-than-3-e-vowels?
          (file->lines "../../data/unixdict.txt")))

(module+ main
  qualifying-words)
