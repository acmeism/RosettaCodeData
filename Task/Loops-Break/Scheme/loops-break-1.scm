(let loop ((first (random 20)))
  (print first)
  (if (not (= first 10))
      (begin
        (print (random 20))
        (loop (random 20)))))
