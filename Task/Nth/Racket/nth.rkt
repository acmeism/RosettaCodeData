#lang racket
(define (teen? n) (<= 11 (modulo n 100) 19))
(define (Nth n)
  (format
   "~a'~a" n
   (match* ((modulo n 10) n)
     [((or 1 2 3) (? teen?)) 'th] [(1 _) 'st] [(2 _) 'nd] [(3 _) 'rd] [(_ _) 'th])))

(for ((range (list  (in-range 26) (in-range 250 266) (in-range 1000 1026))))
  (displayln (string-join (for/list ((nth (sequence-map Nth range))) nth) " ")))
