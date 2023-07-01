(ns amb
  (:use clojure.contrib.monads))

(defn amb [wss]
  (let [valid-word (fn [w1 w2]
                     (if (and w1 (= (last w1) (first w2)))
                       (str w1 " " w2)))]
    (filter #(reduce valid-word %)
            (with-monad sequence-m (m-seq wss)))))

amb> (amb '(("the" "that" "a") ("frog" "elephant" "thing") ("walked" "treaded" "grows") ("slowly" "quickly")))
(("that" "thing" "grows" "slowly"))
