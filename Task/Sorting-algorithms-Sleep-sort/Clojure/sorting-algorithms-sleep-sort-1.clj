(ns sleepsort.core
  (require [clojure.core.async :as async :refer [chan go <! <!! >! timeout]]))

(defn sleep-sort [l]
  (let [c (chan (count l))]
    (doseq [i l]
      (go (<! (timeout (* 1000 i)))
          (>! c i)))
    (<!! (async/into [] (async/take (count l) c)))))
