(def a (int (input "Enter value of a: ")))
(def b (int (input "Enter value of b: ")))

(print (cond [(< a b) "a is less than b"]
             [(> a b) "a is greater than b"]
             [(= a b) "a is equal to b"]))
