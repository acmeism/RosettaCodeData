(lib 'tree)

;; displays a chain hit
(define (power-hit target chain)
	(vector-push chain target)
	(printf "L(%d) = %d - chain:%a "
		target (1- (vector-length chain)) chain)
	(vector-pop chain))
	
;; build the power-tree : add 1 level of leaf nodes
;; display all chains which lead to target

(define (add-level node chain  target  nums (new))
(vector-push chain (node-datum node))
	(cond
	[(node-leaf? node)
	;; add leaves by summing this node to all nodes in chain
	;; do not add leaf if number already known
			 (for [(prev chain)]
			 		(set! new (+ prev (node-datum node)))
			 		(when (= new target) (power-hit target chain ))
			 		#:continue (vector-search* new nums)
			 		(node-add-leaf node new)
			 		(vector-insert* nums new)
			 		)]
	[else ;; not leaf node -> recurse
	(for [(son  (node-sons node))]
		(add-level son chain target nums )) ])
	(vector-pop chain))
	
;; add levels in tree until target found
;; return (number of nodes . upper-bound for L(target))
(define (power-tree target)
	(define nums (make-vector 1 1)) ;; known nums =  1
	(define T (make-tree 1)) ;; root node has value 1
	(printf "Looking for %d in %a." target T)
	(while #t
	#:break (vector-search* target nums) =>  (tree-count T)
	(add-level T init-chain: (make-vector 0) target  nums)
	))
