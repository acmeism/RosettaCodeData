(defn fs [f s] (map f s))
(defn f1 [x] (* 2 x))
(defn f2 [x] (* x x))
(def fsf1 (partial fs f1))
(def fsf2 (partial fs f2))

(each s [@[0 1 2 3] @[2 4 6 8]]
  (printf "Results for array %n." s)
  (printf "fsf1: %n." (fsf1 s))
  (printf "fsf2: %n." (fsf2 s)))
