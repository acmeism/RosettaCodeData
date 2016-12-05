(define (ordered? str)
  (for/and ([i (in-range 1 (string-length str))])
    (string-ci<=? (string-ref str (1- i)) (string-ref str i))))

(define (ordre words)
(define wl 0)
(define s 's)
	(for/fold (len 0) ((w words))
		(set! wl (string-length w))
		#:continue (< wl len)
		#:when (ordered? w)
		#:continue (and (= len wl) (push s w))
		(push (stack s) w) ;; start a new list of length wl
		wl)
	(stack->list s))
	
;; output
(load 'unixdict)
(ordre (text-parse unixdict))
   → (abbott accent accept access accost almost bellow billow biopsy chilly choosy choppy effort floppy glossy knotty)

;; with the dictionaries provided with EchoLisp
;; french
  → (accentué) ;; ordered, longest, and ... self-reference
;; english
  → (Adelops alloquy beefily begorry billowy egilops)
