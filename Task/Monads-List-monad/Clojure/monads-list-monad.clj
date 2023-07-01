(defn bind [coll f] (apply vector (mapcat f coll)))
(defn unit [val] (vector val))

(defn doubler [n] [(* 2 n)])   ; takes a number and returns a List number
(def vecstr (comp vector str)) ; takes a number and returns a List string

(bind (bind (vector 3 4 5) doubler) vecstr) ; evaluates to ["6" "8" "10"]
(-> [3 4 5]
  (bind doubler)
  (bind vecstr)) ; also evaluates to ["6" "8" "10"]
