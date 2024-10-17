(define qc '#(0 1 1))
(define filled 3)
(define len 3)

;; chicken scheme: vector-resize!
;; gambit: vector-append
(define (extend-qc)
  (let* ((new-len (* 2 len))
	 (new-qc (make-vector new-len)))
    (let copy ((n 0))
      (if (< n len)
	(begin
	  (vector-set! new-qc n (vector-ref qc n))
	  (copy (+ 1 n)))))
    (set! len new-len)
    (set! qc new-qc)))

(define (q n)
  (let loop ()
    (if (>= filled len) (extend-qc))
    (if (>= n filled)
      (begin
	(vector-set! qc filled (+ (q (- filled (q (- filled 1))))
				  (q (- filled (q (- filled 2))))))
	(set! filled (+ 1 filled))
	(loop))
      (vector-ref qc n))))

(display "Q(1 .. 10): ")
(let loop ((i 1))
  ;; (print) behave differently regarding newline across compilers
  (display (q i))
  (display " ")
  (if (< i 10)
    (loop (+ 1 i))
    (newline)))

(display "Q(1000): ")
(display (q 1000))
(newline)

(display "bumps up to 100000: ")
(display
  (let loop ((s 0) (i 1))
    (if (>= i 100000) s
      (loop (+ s (if (> (q i) (q (+ 1 i))) 1 0)) (+ 1 i)))))
(newline)
