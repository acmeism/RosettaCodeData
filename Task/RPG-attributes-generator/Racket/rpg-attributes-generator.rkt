#lang racket

(define (d6 . _)
  (+ (random 6) 1))

(define (best-3-of-4d6 . _)
  (apply + (rest (sort (build-list 4 d6) <))))

(define (generate-character)
  (let* ((rolls (build-list 6 best-3-of-4d6))
         (total (apply + rolls)))
    (if (or (< total 75) (< (length (filter (curryr >= 15) rolls)) 2))
        (generate-character)
        (values rolls total))))

(module+ main
  (define-values (rolled-stats total) (generate-character))
  (printf "Rolls:\t~a~%Total:\t~a" rolled-stats total))
