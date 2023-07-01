(lib 'struct)
(lib 'sql) ;; for table

(define T (make-table (struct meal (name poids price))))

(define meals
  '((🐂-beef 	3.8 	36)
    (🍖-pork 	5.4 	43)
    (🍗-ham 	3.6 	90)
    (🐪-greaves 	2.4 	45)
    (flitch 	4.0 	30)
    (brawn 	2.5 	56)
    (welt 	3.7 	67)
    (🐃--salami 	3.0 	95)
    (🐖-sausage 	5.9 	98)))

(list->table meals T)
;; sort table according to best price/poids ratio
(define (price/poids a b  )
	(-  (//  (* (meal-price b) (meal-poids a)) (meal-price a) (meal-poids b)) 1))
(table-sort T price/poids)

(define-syntax-rule (name i) (table-xref T i 0))
(define-syntax-rule (poids i) (table-xref T i 1))

;; shop : add items in basket, in order, until W exhausted
(define (shop W )
	(for/list ((i (table-count T)))
	#:break (<= W 0)
		(begin0
		(cons (name i) (if  (<= (poids i) W) 'all W))
		(set! W (- W (poids i))))))

;; output
(shop 15)
   → ((🐃--salami . all) (🍗-ham . all) (brawn . all) (🐪-greaves . all) (welt . 3.5))
