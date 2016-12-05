(define (balance str)
	(for/fold (closed 0) ((par str))
	 #:break (< closed 0 ) => closed
	(+ closed
	(cond
		((string=? par "[")  1)
		((string=? par "]") -1)
		(else 0)))))
		
(define (task N)
(define str (list->string (append (make-list N "[") (make-list N "]"))))
	(for ((i 10))
	(set! str (list->string (shuffle (string->list str))))
	(writeln  (if (zero? (balance str)) '👍  '❌ ) str)))

(task 4)

❌     "[]]][[]["
❌     "]][][[[]"
❌     "][[[]]]["
👍     "[][[[]]]"
❌     "]][[][]["
❌     "][][[[]]"
👍     "[][][[]]"
❌     "]][[][[]"
❌     "[[]]][[]"
❌     "[[][]]]["
	
