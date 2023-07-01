(let* ((keys (list 'foo 'bar 'baz))
       (vals (list '"foo data" '"bar data" '"baz data"))
       (tuples (: lists zipwith
                 (lambda (a b) (tuple a b)) keys vals))
       (my-dict (: dict from_list tuples)))
  (: io format '"fetched data: ~p~n" (list (: dict fetch 'baz my-dict))))
