(defn jortsort [xs]
  (deep= xs (sorted xs)))

(print (jortsort @[1 2 3 4 5])) # true
(print (jortsort @[2 1 3 4 5])) # false
