; median.lsp
; oofoe 2012-01-25

(define (median lst)
  (sort lst) ; Sorts in place.
  (if (empty? lst)
      nil
    (letn ((n (length lst))
           (h (/ (- n 1) 2)))
          (if (zero? (mod n 2))
              (div (add (lst h) (lst (+ h 1))) 2)
            (lst h))
          )))


(define (test lst) (println lst " -> " (median lst)))

(test '())
(test '(5 3 4))
(test '(5 4 2 3))
(test '(3 4 1 -8.4 7.2 4 1 1.2))

(exit)
