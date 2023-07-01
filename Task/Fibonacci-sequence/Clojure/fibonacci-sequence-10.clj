(ns fib.core)
(require '[clojure.core.async
           :refer [<! >! >!! <!! timeout chan alt! go]])

(defn fib [c]
  (loop [a 0 b 1]
    (>!! c a)
    (recur b (+ a b))))


(defn -main []
  (let [c (chan)]
    (go (fib c))
    (dorun
      (for [i (range 10)]
        (println (<!! c))))))
