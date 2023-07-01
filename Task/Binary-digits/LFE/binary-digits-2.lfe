(: lists foreach
  (lambda (x)
    (: io format
      '"~s~n"
      (list (: erlang integer_to_list x 2))))
  (list 5 50 9000))
