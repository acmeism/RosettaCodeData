;; topological sort
;;
;; Complexity O (# of vertices + # of edges)

(define (t-sort g)
	(stack 'Z) ; vertices of d°(0)
	(stack 'S) ; ordered result

;; mark all vertices with their in-degree = # of incoming arcs
;; push all vertices u such as d°(u) = 0
	(for ((u g)) (mark u (graph-vertex-indegree g u))
	             (when (zero? (mark? u)) (push 'Z u)))
	
;pop a d°(0) vertex u - add it to result
;decrement in-degree of all v vertices u->v
; if d°(v) = 0, push it

(while (not (stack-empty? 'Z))
  			(let  (( u (pop 'Z)))
 			(push 'S u)
			 (for ((v (graph-vertex-out g u)))
				  (mark v (1- (mark? v)))
				  (when (zero? (mark? v)) (push 'Z v)))))
				
;; finish
		 (writeln 't-sort (map vertex-label (stack->list 'S)))
		
;; check no one remaining
		(for ((u g))
		(unless (zero? (mark? u))
		(error " ♻️ t-sort:cyclic" (map vertex-label (graph-cycle g))))))
