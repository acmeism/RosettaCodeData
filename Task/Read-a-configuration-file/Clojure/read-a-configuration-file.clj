(ns read-conf-file.core
  (:require [clojure.java.io :as io]
            [clojure.string :as str])
  (:gen-class))

(def conf-keys ["fullname"
                "favouritefruit"
                "needspeeling"
                "seedsremoved"
                "otherfamily"])

(defn get-lines
  "Read file returning vec of lines."
  [file]
  (try
    (with-open [rdr (io/reader file)]
      (into [] (line-seq rdr)))
    (catch Exception e (.getMessage e))))

(defn parse-line
  "Parse passed line returning vec: token, vec of values."
  [line]
  (if-let [[_ k v] (re-matches #"(?i)^\s*([a-z]+)(?:\s+|=)?(.+)?$" line)]
    (let [k (str/lower-case k)]
      (if v
        [k (str/split v #",\s*")]
        [k [true]]))))

(defn mk-conf
  "Build configuration map from lines."
  [lines]
  (->> (map parse-line lines)
       (filter (comp not nil?))
       (reduce (fn
                 [m [k v]]
                 (assoc m k v)) {})))

(defn output
  [conf-keys conf]
  (doseq [k conf-keys]
    (let [v (get conf k)]
      (if v
        (println (format "%s = %s" k (str/join ", " v)))
        (println (format "%s = %s" k "false"))))))

(defn -main
  [filename]
  (output conf-keys (mk-conf (get-lines filename))))
