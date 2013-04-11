;; max is which fib number you'd like computed (0th, 1st, 2nd, etc.)
;; n is which fib number you're on for this call (0th, 1st, 2nd, etc.)
;; j is the nth fib number (ex. when n = 5, j = 5)
;; i is the nth - 1 fib number
(defn- fib-iter
  [max n i j]
  (if (= n max)
    j
    (recur max
           (inc n)
           j
           (+ i j))))

(defn fib
  [max]
  (if (< max 2)
    max
    (fib-iter max 1 0N 1N)))
