(defmacro if2
  [cond1 cond2 both-true first-true second-true both-false]
  `(case [~cond1 ~cond2]
     [true true]   ~both-true,
     [true false]  ~first-true,
     [false true]  ~second-true
     [false false] ~both-false))
