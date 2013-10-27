(define (det2 eqnx eqny get-one get-oth)
  (- (* (get-one eqnx) (get-oth eqny)) (* (get-one eqny) (get-oth eqnx))))

(define (cramer2 eqnx eqny get-val get-unk get-oth)
  (/ (det2 eqnx eqny get-val get-oth)
     (det2 eqnx eqny get-unk get-oth)))
