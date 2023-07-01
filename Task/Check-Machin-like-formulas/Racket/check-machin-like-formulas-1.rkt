#lang racket
(define (reduce e)
  (match e
    [(? number? a)                         a]
    [(list '+ (? number? a) (? number? b)) (+ a b)]
    [(list '- (? number? a) (? number? b)) (- a b)]
    [(list '- (? number? a))               (- a)]
    [(list '* (? number? a) (? number? b)) (* a b)]
    [(list '/ (? number? a) (? number? b)) (/ a b)]
    [(list '+ a b)                         (reduce `(+ ,(reduce a) ,(reduce b)))]
    [(list '- a b)                         (reduce `(- ,(reduce a) ,(reduce b)))]
    [(list '- a)                           (reduce `(- ,(reduce a)))]
    [(list '* a b)                         (reduce `(* ,(reduce a) ,(reduce b)))]
    [(list '/ a b)                         (reduce `(/ ,(reduce a) ,(reduce b)))]
    [(list 'tan (list 'arctan a))          (reduce a)]
    [(list 'tan (list '- a))               (reduce `(- ,(reduce `(tan ,a))))]
    [(list 'tan (list '+ a b))             (reduce `(/ (+ (tan ,a) (tan ,b))
                                                       (- 1 (* (tan ,a) (tan ,b)))))]
    [(list 'tan (list '+ a b c ...))       (reduce `(tan (+ ,a (+ ,b ,@c))))]
    [(list 'tan (list '- a b))             (reduce `(/ (+ (tan ,a) (tan (- ,b)))
                                                       (- 1 (* (tan ,a) (tan (- ,b))))))]
    [(list 'tan (list '* 1 a))             (reduce `(tan ,a))]
    [(list 'tan (list '* (? number? n) a))
     (cond [(< n 0) (reduce `(- (tan (* ,(- n) ,a))))]
           [(= n 0) 0]
           [(even? n) (reduce `(tan (+ (* ,(/ n 2) ,a) (* ,(/ n 2) ,a))))]
           [else      (reduce `(tan (+ ,a  (* ,(- n 1) ,a))))])]))

(define correct-formulas
  '((tan (+ (arctan 1/2) (arctan 1/3)))
    (tan (+ (* 2 (arctan 1/3)) (arctan 1/7)))
    (tan (- (* 4 (arctan 1/5)) (arctan 1/239)))
    (tan (+ (* 5 (arctan 1/7)) (* 2 (arctan 3/79))))
    (tan (+ (* 5 (arctan 29/278)) (* 7 (arctan 3/79))))
    (tan (+ (arctan 1/2) (arctan 1/5) (arctan 1/8)))
    (tan (+ (* 4 (arctan 1/5)) (* -1 (arctan 1/70)) (arctan 1/99)))
    (tan (+ (* 5 (arctan 1/7)) (* 4 (arctan 1/53)) (* 2 (arctan 1/4443))))
    (tan (+ (* 6 (arctan 1/8)) (* 2 (arctan 1/57)) (arctan 1/239)))
    (tan (+ (* 8 (arctan 1/10)) (* -1 (arctan 1/239)) (* -4 (arctan 1/515))))
    (tan (+ (* 12 (arctan 1/18)) (* 8 (arctan 1/57)) (* -5 (arctan 1/239))))
    (tan (+ (* 16 (arctan 1/21)) (* 3 (arctan 1/239)) (* 4 (arctan 3/1042))))
    (tan (+ (* 22 (arctan 1/28)) (* 2 (arctan 1/443)) (* -5 (arctan 1/1393)) (* -10 (arctan 1/11018))))
    (tan (+ (* 22 (arctan 1/38)) (* 17 (arctan 7/601)) (* 10 (arctan 7/8149))))
    (tan (+ (* 44 (arctan 1/57)) (* 7 (arctan 1/239)) (* -12 (arctan 1/682)) (* 24 (arctan 1/12943))))
    (tan (+ (* 88 (arctan 1/172)) (* 51 (arctan 1/239)) (* 32 (arctan 1/682))
            (* 44 (arctan 1/5357)) (* 68 (arctan 1/12943))))))

(define wrong-formula
  '(tan (+ (* 88 (arctan 1/172)) (* 51 (arctan 1/239)) (* 32 (arctan 1/682))
           (* 44 (arctan 1/5357)) (* 68 (arctan 1/12944)))))

(displayln "Do all correct formulas reduce to 1?")
(for/and ([f correct-formulas]) (= 1 (reduce f)))

(displayln "The incorrect formula reduces to:")
(reduce wrong-formula)
