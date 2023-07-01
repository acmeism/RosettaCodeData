(de accumulator (Sum)
   (curry (Sum) (N)
      (inc 'Sum N) ) )

(def 'a (accumulator 7))
(a 1)  # Output: -> 8
(a 2)  # Output: -> 10
(a -5)  # Output: -> 5
