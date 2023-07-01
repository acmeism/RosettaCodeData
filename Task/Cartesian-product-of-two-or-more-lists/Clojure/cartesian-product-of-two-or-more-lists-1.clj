 (ns clojure.examples.product
	(:gen-class)
	(:require [clojure.pprint :as pp]))

(defn cart [colls]
  "Compute the cartesian product of list of lists"
  (if (empty? colls)
    '(())
    (for [more (cart (rest colls))
          x (first colls)]
      (cons x more))))
