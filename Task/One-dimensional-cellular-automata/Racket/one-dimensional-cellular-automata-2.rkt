#lang slideshow

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simulation of cellular automata, as described by Stephen Wolfram in his 1983 paper.
;; Uses Racket's inline image display capability for visual presentation	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/draw)
(require slideshow)

(define *rules* '((1 1 1) (1 1 0) (1 0 1) (1 0 0)
		  (0 1 1) (0 1 0) (0 0 1) (0 0 0)))

(define (bordered-square n)
  (filled-rectangle n n #:draw-border? #t))

(define (draw-row lst)
  (apply hc-append 2 (map (λ (x) (colorize (bordered-square 10) (cond ((= x 0) "gray")
								      ((= x 1) "red")
								      (else "gray"))))
			  lst)))

(define (extract-neighborhood nth prev-row)
  (take (drop (append '(0) prev-row '(0)) nth) 3))

(define (automaton-to-bits n)
  (reverse (map (λ (y) (if (zero? (bitwise-and y n)) 0 1))
		(map (λ (x) (expt 2 x)) (range 0 8)))))

(define (get-rules bits)
  (map cdr (filter (λ (x) (= (car x) 1)) (map cons bits *rules*))))

(define (advance-row old-row rules)
  (let ([new '()])
    (for ([i (in-range 0 (length old-row))])
      (set! new (cons (if (member (extract-neighborhood i old-row)
				  rules) 1 0) new)))
    (reverse new)))

(define (draw-automaton automaton init-row row-number)
  (let* ([bit-representation (automaton-to-bits automaton)]
	 [rules (get-rules bit-representation)]
	 [rows (list init-row)])
    (for ([i (in-range 1 row-number)])
      (set! rows (cons (advance-row (car rows) rules)
		       rows)))
    (apply vc-append 2 (map draw-row (reverse rows)))))

(draw-automaton 104 '(0 1 1 1 0 1 1 0 1 0 1 0 1 0 1 0 0 1 0 0) 10)
