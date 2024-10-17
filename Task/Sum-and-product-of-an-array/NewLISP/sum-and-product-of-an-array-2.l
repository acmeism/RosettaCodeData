(let (a (array 5 (sequence 1 5)))
  (println "Sum: " (apply + a))
  (println "Product: " (apply * a)))
