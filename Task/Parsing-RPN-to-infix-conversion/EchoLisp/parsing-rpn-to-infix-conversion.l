(require 'hash)
(string-delimiter "")

(define (^ a b ) (expt a b)) ;; add this not-native function
(define-syntax-rule (r-assoc? op) (= op  "^"))
(define-syntax-rule (l-assoc? op) (not ( = op "^" )))
(define PRECEDENCES (list->hash
	'(("+" . 2) ("-" . 2) ("*" . 3) ("/" . 3) ("//" . 3) ("^" . 4))
	(make-hash)))

;; RPN vector or list -> infix tree  ->  (a op (b op c) d) ..
(define (rpn->infix rpn)
(define S (stack 'S))
	(for ((token rpn))
	(if (procedure? token)
		(let [(op2 (pop S)) (op1 (pop S))]
			(unless (and op1 op2)   (error "cannot translate expression" rpn))
	    	(push S (list op1 token op2))
	    	)
	    (push S token ))
	(writeln 'token (string token) 'stack (stack->list S)))
	(begin0
		(pop S) ;; return (top S)
		(unless (stack-empty? S) (error "ill-formed rpn" rpn)))
	)
	
;; a node  tree is (left op right) or a  number
(define-syntax-id _.left (first _)) ; mynode.left expands to (first mynode)
(define-syntax-id _.right (third _))
(define-syntax-id _.op  (string (second _ )))
(define-syntax-rule (precedence node) (hash-ref PRECEDENCES (string (second node))))

(define (left-par? node) ; does lhs needs ( lhs ) ?
	(cond
	[(number? node.left) #f]
	[(< (precedence node.left) (precedence node)) #t]
	[(and
		 	(r-assoc? node.op)
		 	(= (precedence node.left) (precedence node))) #t]
	[else #f]))
	
(define (right-par? node)
	(cond
	[(number? node.right) #f]
	[(< (precedence node.right) (precedence node)) #t]
	[(and
		 	(l-assoc? node.op)
		 	(= (precedence node.right) (precedence node))) #t]
	[else #f]))
	
;; infix tree -> char string
(define (infix->string node)
	(cond
	[(number? node) (string node)]
	[else (let
		[(lhs (infix->string node.left))
		(rhs (infix->string node.right))]
		(when (left-par? node) (set! lhs (string-append "(" lhs ")")))
		(when (right-par? node) (set! rhs (string-append "(" rhs ")")))
		(string-append lhs " " node.op " " rhs))]))
