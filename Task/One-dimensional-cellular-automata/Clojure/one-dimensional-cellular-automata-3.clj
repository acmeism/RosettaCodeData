#!/usr/bin/env lein-exec

(require '[clojure.string :as str])

(def first-genr "_###_##_#_#_#_#__#__")

(def hospitable #{"_##"
                  "##_"
                  "#_#"})

(defn compute-next-genr
  [genr]
  (let [genr      (str "_" genr "_")
        groups    (map str/join (partition 3 1 genr))
        next-genr (for [g groups]
                    (if (hospitable g) \# \_))]
    (str/join next-genr)))

;; ---------------- main -----------------
(loop [g  first-genr
       i  0]
  (if (not= i 10)
    (do (println g)
        (recur (compute-next-genr g)
               (inc i)))))
