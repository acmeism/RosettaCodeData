(defn sum-mul [n f]
  (let [n1 (/' (inc' n) f)]
    (*' f n1 (inc' n1) 1/2)

(def sum-35 #(-> % (sum-mul 3) (+ (sum-mul % 5)) (- (sum-mul % 15))))
(println (sum-35 1000000000))
