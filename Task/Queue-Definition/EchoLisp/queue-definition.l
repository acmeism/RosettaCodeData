;; put info string in permanent storage for later use
(info 'make-Q
"usage: (define q (make-Q)) ;  (q '[top | empty? | pop | push value | to-list | from-list list])")

;; make-Q
(define (make-Q)
  (let ((q (make-vector 0)))
    (lambda (message . args)
      (case message
        ((empty?) (vector-empty? q))
        ((top) (if (vector-empty? q) (error  'Q:top:empty q) (vector-ref q 0)))
        ((push) (vector-push q (car args)))
        ((pop) (if (vector-empty? q) (error 'Q:pop:empty q) (vector-shift q)))
        ((to-list) (vector->list q))
        ((from-list) (set! q (list->vector (car args))) q )
        (else (info 'make-Q) (error  "Q:bad message:" message )))))) ; display info if unknown message

;;
(define q (make-Q))
(q 'empty?) → #t
(q 'push 'first) → first
(q 'push 'second) → second
(q 'pop) → first
(q 'pop) → second
(q 'top)
"💬 error: Q:top:empty #()"
(q 'from-list '( 6 7 8)) → #( 6 7 8)
(q 'top) → 6
(q 'pop) → 6
(q 'to-list)→ (7 8)
(q 'delete)
"💭 error: Q:bad message: delete"

;; save make-Q
(local-put 'make-Q)
