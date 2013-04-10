(use 'double-list)
;=> nil
(def dl (double-list (range 10)))
;=> #'user/dl
dl
;=> (0 <-> 1 <-> 2 <-> 3 <-> 4 <-> 5 <-> 6 <-> 7 <-> 8 <-> 9)
(remove-node dl (get-tail dl))
;=> (0 <-> 1 <-> 2 <-> 3 <-> 4 <-> 5 <-> 6 <-> 7 <-> 8)
dl
;=> (0 <-> 1 <-> 2 <-> 3 <-> 4 <-> 5 <-> 6 <-> 7 <-> 8 <-> 9)
((juxt seq rseq) dl)
;=> [(0 1 2 3 4 5 6 7 8 9) (9 8 7 6 5 4 3 2 1 0)]
(remove-node dl (get-nth dl 5))
;=> (0 <-> 1 <-> 2 <-> 3 <-> 4 <-> 6 <-> 7 <-> 8 <-> 9)
(add-after *1 (get-nth *1 4) 10)
;=> (0 <-> 1 <-> 2 <-> 3 <-> 4 <-> 10 <-> 6 <-> 7 <-> 8 <-> 9)
(get-head *1)
;=> #:double_list.Node{:prev nil, :next #<Object ...>, :data 0, :key <Object ...>}
(get-next *1)
;=> #:double_list.Node{:prev #<Object ...>, :next #<Object ...>, :data 1, :key #<Object ...>}
(get-prev *1)
;=> #:double_list.Node{:prev #<Object ...>, :next #<Object ...>, :data 1, :key #<Object ...>}
