(defn fibs []
  (map first ;; throw away the "metadata" (see below) to view just the fib numbers
       (iterate ;; create an infinite sequence of [prev, curr] pairs
         (fn [[a b]] ;; to produce the next pair, call this function on the current pair
           [b (+ a b)]) ;; new prev is old curr, new curr is sum of both previous numbers
         [0 1]))) ;; recursive base case: prev 0, curr 1
