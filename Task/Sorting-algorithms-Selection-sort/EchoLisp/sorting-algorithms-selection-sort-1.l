;; recursive version (adapted from Racket)
(lib 'list) ;; list-delete
(define (sel-sort xs  (x0))
	(cond
		[(null? xs) null]
		[else (set! x0 (apply min xs))
			  (cons x0 (sel-sort (list-delete xs x0)))]))

(sel-sort (shuffle (iota 13)))
    → (0 1 2 3 4 5 6 7 8 9 10 11 12)

;; straightforward and more efficient implementation using list-swap!
(define (sel-sort list)
		(maplist (lambda( L)
			(first (list-swap! L (first L) (apply min L )))) list))
			
(sel-sort (shuffle (iota 13)))
    → (0 1 2 3 4 5 6 7 8 9 10 11 12)
