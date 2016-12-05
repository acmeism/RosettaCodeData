(lib 'math)
(lib 'match)
(math-precision 1.e-10)

;; formally derive (tan ..) expressions
;; copied from Racket
;; adapted and improved for performance

(define (reduce e)
;; (set! rcount (1+ rcount)) ;; # of calls
  (match e
    [(? number? a)                         a]
    [('+ (? number? a) (? number? b)) (+ a b)]
    [('- (? number? a) (? number? b)) (- a b)]
    [('- (? number? a))               (- a)]
    [('* (? number? a) (? number? b)) (* a b)]
    [('/ (? number? a) (? number? b)) (/ a b)] ; patch

    [( '+ a b)                         (reduce `(+ ,(reduce a) ,(reduce b)))]
    [( '- a b)                         (reduce `(- ,(reduce a) ,(reduce b)))]
    [( '- a)                           (reduce `(- ,(reduce a)))]
    [( '* a b)                         (reduce `(* ,(reduce a) ,(reduce b)))]
    [( '/ a b)                         (reduce `(/ ,(reduce a) ,(reduce b)))]

    [( 'tan ('arctan a))           (reduce a)]
    [( 'tan ( '- a))               (reduce `(- (tan ,a)))]

    ;; x 100 # calls reduction : derive (tan ,a) only once
    [( 'tan ( '+ a b))
          (let ((alpha (reduce  `(tan ,a))) (beta (reduce  `(tan ,b))))
    	  (reduce `(/ (+ ,alpha ,beta) (- 1 (* ,alpha ,beta)))))]

    [( 'tan ( '+ a b c ...))       (reduce `(tan (+ ,a (+ ,b ,@c))))]

    [( 'tan ( '- a b))
                (let ((alpha (reduce  `(tan ,a))) (beta (reduce  `(tan ,b))))
    		(reduce `(/ (- ,alpha ,beta) (+ 1 (* ,alpha ,beta)))))]

    ;; add formula for (tan 2 (arctan a)) = 2 a / (1 - a^2))
    [( 'tan ( '* 2 ('arctan a)))   (reduce `(/ (* 2 ,a) (- 1 (* ,a ,a))))]
    [( 'tan ( '* 1 ('arctan a)))   (reduce a)] ; added

    [( 'tan ( '* (? number? n) a))
     (cond [(< n 0) (reduce `(- (tan (* ,(- n) ,a))))]
           [(= n 0) 0]
           [(= n 1)    (reduce `(tan ,a))]
           [(even? n)
              (let ((alpha (reduce  `(tan (* ,(/ n 2) ,a))))) ;; # calls reduction
    	      (reduce `(/ (* 2 ,alpha) (- 1 (* ,alpha ,alpha)))))]
           [else      (reduce `(tan (+ ,a  (* ,(- n 1) ,a))))])]
    ))

(define (task)
	(for ((f machins))
	(if (~= 1 (reduce f))
		(writeln '👍 f  '⟾ 1 )
		(writeln '❌ f '➽ (reduce f) ))))
	
