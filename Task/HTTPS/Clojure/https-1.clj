(use '[clojure.contrib.duck-streams :only (slurp*)])
(print (slurp* "https://sourceforge.net"))
