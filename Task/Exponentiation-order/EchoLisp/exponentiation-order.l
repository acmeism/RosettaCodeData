;; the standard and secure way is to use the (expt a b) function
(expt 5 (expt 3 2))  ;; 5 ** ( 3 ** 2)
    → 1953125
(expt (expt 5 3) 2) ;; (5 ** 3) ** 2
    → 15625

;; infix EchoLisp may use the ** operator, which right associates
(lib 'match)
(load 'infix.glisp)

(5 ** 3 ** 2)
    → 1953125
((5 ** 3) ** 2)
    → 15625
(5 ** (3 ** 2))
    → 1953125
