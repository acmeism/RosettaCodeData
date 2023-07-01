(require 'sequences)
(define ALPHABET (list->vector  ["A" .. "Z"] ))
(vector-push ALPHABET " ")

(define (fitness source target) ;; score >=0, best is 0
	(for/sum  [(s source)(t target)]
		(if (= s t) 0 1)))
		
(define (mutate source rate)
	(for/string [(s source)]
		(if (< (random) rate) [ALPHABET (random 27)] s)))
		
(define (select parent target rate copies (copy) (score))
	(define best (fitness parent target))
	(define selected parent)
	(for [(i copies)]
		(set! copy (mutate parent rate))
		(set! score (fitness copy target))
		(when (< score  best)
			(set! selected copy)
			(set! best  score)))
	selected )
	
(define MUTATION_RATE 0.05) ;; 5% chances to change
(define COPIES 100)
(define TARGET "METHINKS IT IS LIKE A WEASEL")

(define (task (rate MUTATION_RATE) (copies COPIES) (target TARGET) (score))
	(define parent ;; random source
		(for/string
                [(i (string-length target))] [ALPHABET (random 27)]))
		
	(for [(i (in-naturals))]
		(set! score (fitness parent target))
		(writeln i parent 'score score)
		#:break (zero? score)
		(set! parent (select parent target rate copies))
		))
