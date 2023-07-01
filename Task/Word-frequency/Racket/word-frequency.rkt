#lang racket

(define (all-words f (case-fold string-downcase))
  (map case-fold (regexp-match* #px"\\w+" (file->string f))))

(define (l.|l| l) (cons (car l) (length l)))

(define (counts l (>? >)) (sort (map l.|l| (group-by values l)) >? #:key cdr))

(module+ main
  (take (counts (all-words "data/les-mis.txt")) 10))
