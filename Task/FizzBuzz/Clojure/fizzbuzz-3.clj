(map #(let [s (str (if (zero? (mod % 3)) "Fizz") (if (zero? (mod % 5)) "Buzz"))] (if (empty? s) % s)) (range 1 101))
