; uses SRFI-1 library http://srfi.schemers.org/srfi-1/srfi-1.html

(define (evolve ls r)
  (unfold
    (lambda (x) (null? (cddr x)))
    (lambda (x)
      (vector-ref r (+ (* 4 (first x)) (* 2 (second x)) (third x))))
    cdr
    (cons (last ls) (append ls (list (car ls))))))

(define (automaton s r n)
  (define (*automaton s0 rv n)
    (for-each (lambda (x) (display (if (zero? x) #\. #\#))) s0)
    (newline)
    (if (not (zero? n))
      (let ((s1 (evolve s0 rv)))
	(*automaton s1 rv (- n 1)))))
  (display "Rule ")
  (display r)
  (newline)
  (*automaton
    s
    (list->vector
      (append
	(int->bin r)
	(make-list (- 7 (floor (/ (log r) (log 2)))) 0)))
    n))

(automaton '(0 1 0 0 0 1 0 1 0 0 1 1 1 1 0 0 0 0 0 1) 30 20)
