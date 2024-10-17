;Using a generator and a function that apply generated values to a function taking two arguments

;A generator knows commands 'next? and 'next
(define (range a b)
(let ((k a))
(lambda (msg)
(cond
	((eq? msg 'next?) (<= k b))
	((eq? msg 'next)
	(cond
		((<= k b) (set! k (+ k 1)) (- k 1))
		(else 'nothing-left)))))))

;Similar to List.fold_left in OCaml, but uses a generator
(define (fold fun a gen)
(let aux ((a a))
	(if (gen 'next?) (aux (fun a (gen 'next))) a)))

;Now the factorial function
(define (factorial n) (fold * 1 (range 1 n)))

(factorial 8)

;40320
