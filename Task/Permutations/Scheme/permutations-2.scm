; translation of ocaml : mostly iterative, with auxiliary recursive functions for some loops
(define (vector-swap! v i j)
(let ((tmp (vector-ref v i)))
(vector-set! v i (vector-ref v j))
(vector-set! v j tmp)))

(define (next-perm p)
(let* ((n (vector-length p))
	(i (let aux ((i (- n 2)))
	(if (or (< i 0) (< (vector-ref p i) (vector-ref p (+ i 1))))
		i (aux (- i 1))))))
(let aux ((j (+ i 1)) (k (- n 1)))
	(if (< j k) (begin (vector-swap! p j k) (aux (+ j 1) (- k 1)))))
(if (< i 0) #f (begin
	(vector-swap! p i (let aux ((j (+ i 1)))
		(if (> (vector-ref p j) (vector-ref p i)) j (aux (+ j 1)))))
	#t))))

(define (print-perm p)
(let ((n (vector-length p)))
(do ((i 0 (+ i 1))) ((= i n)) (display (vector-ref p i)) (display " "))
(newline)))

(define (print-all-perm n)
(let ((p (make-vector n)))
(do ((i 0 (+ i 1))) ((= i n)) (vector-set! p i i))
(print-perm p)
(do ( ) ((not (next-perm p))) (print-perm p))))

(print-all-perm 3)
; 0 1 2
; 0 2 1
; 1 0 2
; 1 2 0
; 2 0 1
; 2 1 0

;a more recursive implementation
(define (permute p i)
(let ((n (vector-length p)))
(if (= i (- n 1)) (print-perm p)
(begin
	(do ((j i (+ j 1))) ((= j n))
		(vector-swap! p i j)
		(permute p (+ i 1)))
	(do ((j (- n 1) (- j 1))) ((< j i))
		(vector-swap! p i j))))))


(define (print-all-perm-rec n)
(let ((p (make-vector n)))
(do ((i 0 (+ i 1))) ((= i n)) (vector-set! p i i))
(permute p 0)))

(print-all-perm-rec 3)
; 0 1 2
; 0 2 1
; 1 0 2
; 1 2 0
; 2 0 1
; 2 1 0
