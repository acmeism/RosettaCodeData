;; returns quintuple (A s a b c)
;; or #f if not hero
(define (hero a b c (s 0) (A 0))
	(when
	(= 1 (gcd a b c))
	(set! s (// (+ a b c) 2))
	(set! A (* s (- s a)(- s b)(- s c)))
	(when (square? A)
		(list (sqrt A) (* s 2)  c b a))))
		
;; all heroes a,b,c < sidemax
;; sorted by A|s|c & a <=b <= c
(define (heroes (sidemax 201))
	(list-sort/fields 3
	(for*/list ((a (in-range 1 sidemax)) (b (in-range a sidemax)) (c (in-range b sidemax)))
	#:continue (<= (+ a b) c) ;; triangle inequality must hold !! cut search
	#:continue (not (hero a b c))
		(hero a b c))))
		
(define (print-hero h)
		(printf "A: %6d s: %6d    sides: %dx%dx%d"
			(list-ref  h  0) (list-ref  h  1)
			(list-ref h 2)(list-ref h 3) (list-ref h 4)))
(define (print-laurels H)
		(writeln '🌿🌿 (length H) 'heroes '🌿🌿))
