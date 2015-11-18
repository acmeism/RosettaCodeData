(let [n nil fizz (cycle [n n "fizz"]) buzz (cycle [n n n n "buzz"]) nums (iterate inc 1)]
  (take 20 (map #(if (or %1 %2) (str %1 %2) %3) fizz buzz nums)))
