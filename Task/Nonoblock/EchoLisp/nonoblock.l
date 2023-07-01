;; size is the remaining # of cells
;; blocks is the list of remaining blocks size
;; cells is a stack where we push 0 = space or block size.
(define (nonoblock size blocks into: cells)
(cond
	((and (empty? blocks) (= 0 size)) (print-cells (stack->list cells)))
	
	((<= size 0) #f) ;; no hope - cut search
	((> (apply + blocks) size)  #f) ;; no hope - cut search
	
	(else
		(push cells 0) ;; space
		(nonoblock (1- size) blocks  cells)
		(pop cells)

	(when (!empty? blocks)
		(when (stack-empty? cells) ;; first one (no space is allowed)
		(push cells (first blocks))
		(nonoblock  (- size (first blocks)) (rest blocks) cells)
		(pop cells))

		(push cells 0) ;; add space before
		(push cells (first blocks))
		(nonoblock  (- size (first blocks) 1) (rest blocks) cells)
		(pop cells)
		(pop cells)))))
	
(string-delimiter "")
(define block-symbs #( ?  📦 💣 💊  🍒 🌽 📘 📙 💰 🍯 ))

(define (print-cells cells)
	(writeln (string-append "|"
		(for/string ((cell cells))
			(if (zero? cell) "_"
				(for/string ((i cell)) [block-symbs cell]))) "|")))
	
(define (task  nonotest)
	(for ((test nonotest))
		(define size (first test))
		(define blocks (second test))
		(printf "\n size:%d blocks:%d" size blocks)
		(if
			(> (+ (apply + blocks)(1- (length blocks))) size)
				(writeln "❌ no solution for" size blocks)
			    (nonoblock size blocks (stack 'cells)))))
