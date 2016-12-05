(let (((tuple (list (tuple key value)))
       (: jiffy decode '"{\"foo\": [1, 2, 3]}")))
  (: io format '"~p: ~p~n" (list key value)))
