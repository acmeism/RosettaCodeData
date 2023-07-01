(def padovan (map first (iterate (fn [[a b c]] [b c (+ a b)]) [1 1 1])))

(def pad-floor
  (let [p 1.324717957244746025960908854
        s 1.0453567932525329623]
    (map (fn [n] (int (Math/floor (+ (/ (Math/pow p (dec n)) s) 0.5)))) (range))))

(def pad-l
  (iterate (fn f [[c & s]]
             (case c
               \A (str "B" (f s))
               \B (str "C" (f s))
               \C (str "AB" (f s))
               (str "")))
           "A"))

(defn comp-seq [n seqa seqb]
  (= (take n seqa) (take n seqb)))

(defn comp-all [n]
  (= (map count (vec (take n pad-l)))
     (take n padovan)
     (take n pad-floor)))

(defn padovan-print [& args]
  ((print "The first 20 items with recursion relation are: ")
   (println (take 20 padovan))
   (println)
   (println (str
             "The recurrence and floor based algorithms "
             (if (comp-seq 64 padovan pad-floor) "match" "not match")
             " to n=64"))
   (println)
   (println "The first 10 L-system strings are:")
   (println (take 10 pad-l))
   (println)
   (println (str
             "The L-system, recurrence and floor based algorithms "
             (if (comp-all 32) "match" "not match")
             " to n=32"))))
