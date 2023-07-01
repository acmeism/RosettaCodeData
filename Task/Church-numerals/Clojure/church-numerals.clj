(defn zero [f] identity)
(defn succ  [n]   (fn [f] (fn [x] (f ((n f) x)))))
(defn add   [n,m] (fn [f] (fn [x] ((m f)((n f) x)))))
(defn mult  [n,m] (fn [f] (fn [x] ((m (n f)) x))))
(defn power [b,e] (e b))

(defn to-int [c] ((c inc) 0))

(defn from-int [n]
  (letfn [(countdown [i] (if (zero? i) zero (succ (countdown (- i 1)))))]
  (countdown n)))

(def three (succ (succ (succ zero))))
(def four (from-int 4))

(doseq [n [(add three four)   (mult three four)
           (power three four) (power four three)]]
    (println (to-int n)))
