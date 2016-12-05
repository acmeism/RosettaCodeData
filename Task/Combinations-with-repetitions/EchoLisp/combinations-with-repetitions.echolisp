;;
;; native function : combinations/rep in list.lib
;;
(lib 'list)

(combinations/rep '(iced jam plain) 2)
   → ((iced iced) (iced jam) (iced plain) (jam jam) (jam plain) (plain plain))

;;
;; using a combinator iterator
;;
(lib 'sequences)

(take (combinator/rep '(iced jam plain) 2) 8)
    → ((iced iced) (iced jam) (iced plain) (jam jam) (jam plain) (plain plain))

;;
;; or, implementing the function
;;

(define (comb/rep nums k)
	(cond
	[(null? nums) null]
	[(<= k 0) null]
	[(= k 1) (map list nums)]
	[else
		(for/fold (acc null) ((anum nums))
		(append acc
	  		(for/list ((xs (comb/rep nums (1- k))))
	  		#:continue (< (first xs) anum)
	  		(cons anum xs))))]))

(map (curry list-permute '(iced jam plain)) (comb/rep (iota 3) 2))
    → ((iced iced) (iced jam) (iced plain) (jam jam) (jam plain) (plain plain))

;;
;; extra credit
;;

(length (combinator/rep (iota 10) 3))
    → 220
