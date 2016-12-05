(let* ((a '"data assigned to a")
       (b a))
  (: io format '"Contents of 'b': ~s~n" (list b)))
