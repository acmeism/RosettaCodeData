(define (Maybe.domain? x) (or (number? x) (string? x)))
(define (Maybe.unit elem (bool #t)) (cons bool elem))

;; f is a safe or unsafe function
;; (Maybe.lift f) returns a safe Maybe function which returns a Maybe element
(define (Maybe.lift f)
		(lambda(x)
             (let [(u (f x))]
             (if (Maybe.domain? u)
                (Maybe.unit u)
                (Maybe.unit x #f))))) ;; return offending x


;; elem = Maybe element
;; f is safe or unsafe  (lisp) function
;; return Maybe element
(define (Maybe.bind f elem)
		(if (first elem) ((Maybe.lift f)  (rest elem)) elem))
		
;; pretty-print		
(define (Maybe.print elem)
		(if (first elem)  (writeln elem ) (writeln '❌ elem)))

;; unsafe functions
(define (u-log x) (if (> x 0) (log x) #f))
(define (u-inv x) (if (zero? x) 'zero-div (/ x)))

;; (print (number->string (exp (log 3))))
(->> 3 Maybe.unit (Maybe.bind u-log) (Maybe.bind exp)  (Maybe.bind number->string) Maybe.print)
    → (#t . "3.0000000000000004")

;; (print (number->string (exp (log -666))))
(->> -666  Maybe.unit (Maybe.bind u-log) (Maybe.bind exp)  (Maybe.bind number->string) Maybe.print)
     → ❌     (#f . -666)

;; ;; (print (number->string (inverse (log 1))))
(->> 1 Maybe.unit (Maybe.bind u-log)  (Maybe.bind u-inv)  (Maybe.bind number->string) Maybe.print)
     →  ❌     (#f . 0)
