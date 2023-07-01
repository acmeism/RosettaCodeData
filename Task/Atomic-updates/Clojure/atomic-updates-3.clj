(defn equalize [m a b]
  (let [{a-val a b-val b} m
        diff (- a-val b-val)
        amt (/ diff 2)]
    (xfer m a b amt)))

(defn randomize [m a b]
  (let [{a-val a b-val b} m
        min-val (min a-val b-val)
        amt (rand-int (- min-val) min-val)]
    (xfer m a b amt)))

(defn test-conc [f data a b n name]
  (dotimes [i n]
    (swap! data f a b)
    (println (str "total is " (reduce + (vals @data)) " after " name " iteration " i))))

(def thread-eq (Thread. #(test-conc equalize *data* :a :b 1000 "equalize")))
(def thread-rand (Thread. #(test-conc randomize *data* :a :b 1000 "randomize")))

(.start thread-eq)
(.start thread-rand)
