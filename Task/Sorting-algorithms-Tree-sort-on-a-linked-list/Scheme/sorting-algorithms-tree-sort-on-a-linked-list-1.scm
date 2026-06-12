(use matchable)

(define insert
  ;; (insert key tree)
  (match-lambda*
   [(x ())         `(() ,x ()) ]
   [(x (() () ())) `(() ,x ()) ]
   [(x (l k r))
    (=> continue)
    (if (<= x k)
	`(,(insert x l) ,k ,r)
	(continue)) ]
   [(x (l k r)) `(,l ,k ,(insert x r)) ]
   [_ "incorrect arguments or broken tree" ]))

(define in-order
  ;; (in-order tree)
  (match-lambda
   [(() x ()) `(,x)]
   [(l x ())  (append (in-order l) `(,x))]
   [(() x r)  (append `(,x) (in-order r))]
   [(l x r)   (append (in-order l) `(,x) (in-order r))]
   [_ "incorrect arguments or broken tree" ]))

(define (tree-sort lst)
  (define tree-sort-itr
    (match-lambda*
     [(x ())      (in-order x)]
     [(x (a . b)) (tree-sort-itr (insert a x) b)]
     [_ "incorrect arguments or broken tree" ]))
  (tree-sort-itr '(() () ()) lst))
