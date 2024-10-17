(let (xs '(a b c))
  (until (empty? (rest xs))
    (print (pop xs) ", "))
  (println (pop xs)))

a, b, c
