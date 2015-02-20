(ns rosettacode.semordnilaps
  (:require [clojure.string  :as str])
            [clojure.java.io :as io ]))

(def dict-file
  (or (first *command-line-args*) "unixdict.txt"))

(def dict (-> dict-file io/reader line-seq set))

(defn semordnilap? [word]
  (let [rev (str/reverse word)]
    (and (not= word rev) (dict rev))))

(def semordnilaps
  (->> dict
       (filter semordnilap?)
       (map #([% (str/reverse %)]))
       (filter (fn [[x y]] (<= (compare x y) 0)))))

(printf "There are %d semordnilaps in %s.  Here are 5:\n"
  (count semordnilaps)
  dict-file)

(dorun (->> semordnilaps shuffle (take 5) sort (map println)))
