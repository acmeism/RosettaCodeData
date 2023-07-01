;; RPN (postfix) evaluator

(lib 'hash)

(define OPS (make-hash))
(hash-set OPS "^" expt)
(hash-set OPS "*" *)
(hash-set OPS "/" //) ;; float divide
(hash-set OPS "+" +)
(hash-set OPS "-" -)

(define (op? op) (hash-ref OPS op))

;; algorithm : https://en.wikipedia.org/wiki/Reverse_Polish_notation#Postfix_algorithm

(define (calculator rpn S)
	(for ((token rpn))
	(if (op? token)
		(let [(op2 (pop S)) (op1 (pop S))]
			(unless (and op1 op2) (error "cannot calculate expression at:" token))
	    	(push S ((op? token) op1 op2))
	    	(writeln op1 token op2 "→" (stack-top S)))
	    (push S (string->number token))))
	(pop S))
	
(define (task rpn)
 (define S (stack 'S))
 (calculator (text-parse rpn) S ))
