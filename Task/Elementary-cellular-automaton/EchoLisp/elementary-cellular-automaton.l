(lib 'types) ;; int32 vectors
(lib 'plot)

(define-constant BIT0 0)
(define-constant BIT1 (rgb 0.8 0.9 0.7)) ;; colored bit 1

;; integer to pattern
(define ( n->pat n)
		(for/vector ((i 8))
		#:when (bitwise-bit-set? n i)
		(for/vector  ((j (in-range 2 -1 -1)))
		(if (bitwise-bit-set? i j) BIT1  BIT0 ))))
		
;; test if three pixels match a pattern
(define (pmatch a b c pat)
		(for/or ((v pat))
		(and (= a (vector-ref v 0))  (= b (vector-ref v 1))   (= c (vector-ref v 2)) )))
		
;; next generation = next row
(define (generate x0 width PAT PIX (x))
		(for ((dx (in-range 0 width)))
		(set! x (+ x0 dx))
		(vector-set! PIX (+ x width) ;; next row
			(if
			(pmatch
				(vector-ref PIX (if (zero? dx) (+ x0 width) (1- x))) ;; let's wrap
				(vector-ref PIX x)
				(vector-ref PIX (if (= dx (1- width)) x0 (1+ x)))
				PAT)
			BIT1 BIT0))))
		
;; n is the pattern, starters in the number of set pixels at generation 0
(define (task n (starters 1))
		(define width (first (plot-size)))
		(define height (rest (plot-size)))
		(define PAT (n->pat n))
		(plot-clear)
		
		(define PIX (pixels->int32-vector))
		(init-pix  starters  width height PIX)
		
		(for ((y (1- height)))
			(generate (* y width) width PAT into: PIX))
		(vector->pixels PIX))
		
;; put n starters on first row
(define (init-pix starters width height PIX)
	(define dw (floor (/ width (1+ starters))))
	(for ((x (in-range dw width (1+ dw))))
				(vector-set! PIX x BIT1)))

;; usage
(task 99 3) → 672400 ;; ESC to see it
(task 22)   → 672400

;; check pattern generator
(n->pat 13)
    → #( #( 0 0 0) #( 0 -5052980 0) #( 0 -5052980 -5052980))
