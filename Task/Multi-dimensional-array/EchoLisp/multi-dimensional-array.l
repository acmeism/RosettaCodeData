(require 'math) ;; dot-product

;; dims = vector #(d1 d2 .....)
;; allocates a new m-array
(define (make-m-array dims (init 0))
	;; allocate 2 + d1*d2*d3... consecutive cells
	(define msize (apply * (vector->list dims)))
	(define m-array (make-vector (+ 2 msize) init))
	
	;; compute displacements vector once for all
	;; m-array[0] = [1 d1 d1*d2 d1*d2*d3 ...]
	(define disps (vector-rotate! (vector-dup dims) 1))
	(vector-set! disps 0 1)
	(for [(i(in-range 1 (vector-length disps)) )]
	      (vector-set! disps i (* [disps i] [disps (1- i)])))
	(vector-set! m-array 0 disps)
	
	(vector-set! m-array 1 dims) ;; remember dims
	m-array)

;; from indices = #(i j k ...) to displacement
(define-syntax-rule (m-array-index ma indices)
	(+ 2 (dot-product (ma 0)  indices)))
	
;; check i < d1, j < d2, ...
(define (m-array-check ma indices)
	(for [(dim [ma 1]) (idx indices)]
		#:break (>= idx dim) => (error 'm-array:bad-index (list idx  '>= dim))))

;; --------------------
;; A P I
;; --------------------
;; indices is a vector #[i j k ...]
;; (make-m-array (dims) [init])

(define (m-array-dims ma) [ma 1])

; return ma[indices]
(define (m-array-ref ma indices)
	(m-array-check ma indices)
	[ma (m-array-index ma indices)])
; sets ma[indices]
(define (m-array-set! ma indices value )
	(m-array-check ma indices)
	(vector-set! ma (m-array-index ma indices) value))
