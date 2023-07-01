(let ((data '(#(key1 "foo") #(key2 "bar")))
      (hash (: dict from_list data)))
  (: dict fold
    (lambda (key val accum)
      (: io format '"~s: ~s~n" (list key val)))
    0
    hash))
