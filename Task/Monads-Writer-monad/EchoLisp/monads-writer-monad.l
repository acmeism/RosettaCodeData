(define (Writer.unit x (log #f))
	(if log (cons log x)
		(cons (format "init → %d" x) x)))

;; f is a lisp function
;; (Writer.lift f) returns a  Writer function which returns a Writer element

(define (Writer.lift f name)
	(lambda(elem)
             (Writer.unit
             	(f (rest elem))
                (format "%a \n %a  → %a" (first elem) name (f (rest elem))))))

;; lifts and applies
(define (Writer.bind f elem) ((Writer.lift f (string f)) elem))

(define (Writer.print elem) (writeln 'result (rest elem)) (writeln (first elem)))
		
;; Writer monad versions
(define w-root  (Writer.lift sqrt "root"))
(define w-half  (Writer.lift (lambda(x) (// x 2)) "half"))
(define w-inc  ( Writer.lift add1 "add-one"))


;; no binding required, as we use Writer lifted functions
(->  5 Writer.unit w-root w-inc w-half Writer.print)

result 1.618033988749895
init → 5
root → 2.23606797749979
add-one → 3.23606797749979
half → 1.618033988749895

;; binding
(->>  0 Writer.unit (Writer.bind sin) (Writer.bind cos)  w-inc w-half Writer.print)

result 1
init → 0
sin → 0
cos → 1
add-one → 2
half → 1
