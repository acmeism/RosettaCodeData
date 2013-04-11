(use 'clojure.contrib.combinatorics)
(use 'clojure.set)

(def given (apply hash-set (partition 4 5 "ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB" )))
(def s1 (apply hash-set (permutations "ABCD")))  	
(def missing (difference s1 given))
