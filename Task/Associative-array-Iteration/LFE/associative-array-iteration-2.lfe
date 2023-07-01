(let ((data '(#(key1 "foo") #(key2 "bar")))
      (hash (: dict from_list data)))
  (: lists map
    (lambda (key)
      (: io format '"~s~n" (list key)))
    (: dict fetch_keys hash)))
