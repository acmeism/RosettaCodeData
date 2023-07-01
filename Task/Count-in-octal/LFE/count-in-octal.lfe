(: lists foreach
  (lambda (x)
    (: io format '"~p~n" (list (: erlang integer_to_list x 8))))
  (: lists seq 0 2000))
