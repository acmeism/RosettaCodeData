(defn fizzbuzz [start finish]
  (map (fn [n]
	(cond
		(zero? (mod n 15)) "FizzBuzz"
		(zero? (mod n 3)) "Fizz"
		(zero? (mod n 5)) "Buzz"
		:else n))
	(range start finish)))
(fizzbuzz 1 100)
