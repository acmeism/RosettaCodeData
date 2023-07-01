 (define/mem (prime? x)
  (if (= x 1)
    #f
    (not (for/or ([p (in-range 2 x)]
                  #:break (> (sqr p) x))
           (zero? (remainder x p))))))

(define (map* p list)
  (map (lambda (x) (* x p)) list))

(define/mem (part-prod x p)
  (cond
    [(< x 0) '()]
    [(zero? x) (list 1)]
    [(zero? p) '()]
    [(not (prime? p)) (part-prod x (sub1 p))]
    [else (append (map* p (part-prod (- x p) p))
                  (part-prod x (sub1 p)))]))

(define/mem (descendants x)
  (if (= x 4)
      '()
      (sort (part-prod x (sub1 x)) <)))

(define/mem (ancestors z)
  (let ([tmp (for/first ([x (in-range (sub1 z) 0 -1)]
                         #:when (member z (descendants x)))
               (add-tail (ancestors x) x))])
    (if tmp tmp '())))

(define (show-info x)
  (printf "~a " x)
  (printf "Ancestors: ~a ~a " (length (ancestors x)) (ancestors x))
  (printf "Descendants: ~a ~a " (length (descendants x)) (borders (descendants x)))
  (newline))

(define (total-ancestors n)
  (for/sum ([x (in-range 1 (add1 n))])
    (length (ancestors x))))

(define (total-descendants n)
  (for/sum ([x (in-range 1 (add1 n))])
    (length (descendants x))))
