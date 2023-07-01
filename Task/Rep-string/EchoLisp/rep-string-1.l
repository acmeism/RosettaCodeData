(lib 'list) ;; list-rotate

;; a list is a rep-list if equal? to itself after a rotation of lam units
;; lam <= list length / 2
;; truncate to a multiple of lam before rotating
;; try cycles in decreasing lam order (longest wins)

(define (cyclic? cyclic)
    (define len (length cyclic))
    (define trunc null)

    (if (> len 1)
        (for ((lam (in-range (quotient len 2) 0 -1)))
        (set! trunc (take cyclic (- len (modulo len lam))))
         #:break (equal? trunc  (list-rotate trunc lam)) => (list->string (take cyclic lam))
         'no-rep )
   'too-short-no-rep))
