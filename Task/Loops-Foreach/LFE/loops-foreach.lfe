(lists:foreach
  (lambda (x)
    (io:format "item: ~p~n" (list x)))
  (lists:seq 1 10))
