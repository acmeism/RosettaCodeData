(ns rosettacode.textprocessing1
  (:require [clojure.string :as str]))

(defn parse-line [s]
  (let [[date & data-toks] (str/split s #"\s+")]
    {:date date
     :hour-vals (for [[v flag] (partition 2 data-toks)]
                  {:val  (Double. v)
                   :flag (Long. flag)})}))

(defn analyze-line [m]
  (let [valid?  (fn [rec] (pos? (:flag rec)))
        data    (->> (filter valid? (:hour-vals m))
                     (map :val))
        n-vals  (count data)
        sum     (reduce + data)]
    {:date   (:date m)
     :n-vals n-vals
     :sum    (double sum)
     :avg    (if (zero? n-vals) 0.0 (/ sum n-vals))
     :gaps   (for [hr (:hour-vals m)]
               {:gap? (not (valid? hr)) :date (:date m)})}))

(defn print-line [m]
  (println (format "%s: %d valid, sum: %7.3f, mean: %6.3f"
                   (:date   m)
                   (:n-vals m)
                   (:sum m)
                   (:avg m))))

(defn process-line [s]
  (let [m         (parse-line s)
        line-info (analyze-line m)]
    (print-line line-info)
    line-info))

(defn update-file-stats [file-m line-m]
  (let [append (fn [a b] (reduce conj a b))]
    (-> file-m
        (update-in [:sum]    + (:sum line-m))
        (update-in [:n-vals] + (:n-vals line-m))
        (update-in [:gap-recs] append (:gaps line-m)))))

(defn process-file [path]
  (let [file-lines (->> (slurp path)
                        str/split-lines)
        summary (reduce (fn [res line]
                          (update-file-stats res (process-line line)))
                        {:sum 0
                         :n-vals 0
                         :gap-recs []}
                        file-lines)
        max-gap (->> (partition-by :gap? (:gap-recs summary))
                     (filter #(:gap? (first %)))
                     (sort-by count >)
                     first)]
    (println (format "Sum: %f\n# Values: %d\nAvg: %f"
                     (:sum summary)
                     (:n-vals summary)
                     (/ (:sum summary) (:n-vals summary))))
    (println (format "Max gap of %d recs started on %s"
                     (count max-gap)
                     (:date (first max-gap))))))
