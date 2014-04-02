(use '[clojure.math.combinatorics :only [subsets] ])

(def S #{1 2 3 4})

user> (subsets S)
(() (1) (2) (3) (4) (1 2) (1 3) (1 4) (2 3) (2 4) (3 4) (1 2 3) (1 2 4) (1 3 4) (2 3 4) (1 2 3 4))
