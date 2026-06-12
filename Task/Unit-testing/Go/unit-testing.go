(function subject x y z
  (return-unless (num? x) x)
  (return-unless (num? y) y)
  (if x y z))


(assert (= (subject :a 2 3) :a))
(assert (= (subject 1 :b 3) :b))
(assert (= (subject 1 2 3)   2))
