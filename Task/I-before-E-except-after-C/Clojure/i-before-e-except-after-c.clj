(ns i-before-e.core
  (:require [clojure.string :as s])
  (:gen-class))

(def patterns {:cie #"cie" :ie #"(?<!c)ie" :cei #"cei" :ei #"(?<!c)ei"})

(defn update-counts
  "Given a map of counts of matching patterns and a word, increment any count if the word matches it's pattern."
  [counts [word freq]]
  (apply hash-map (mapcat (fn [[k v]] [k (if (re-seq (patterns k) word) (+ freq v) v)]) counts)))

(defn count-ie-ei-combinations
  "Update counts of all ie and ei combinations"
  [words]
  (reduce update-counts {:ie 0 :cie 0 :ei 0 :cei 0} words))

(defn apply-freq-1
  "Apply a frequency of one to words"
  [words]
  (map #(vector % 1) words))

(defn- format-plausible
  [plausible?]
  (if plausible? "plausible" "implausible"))

(defn- apply-rule [desc examples contra]
  (let [plausible? (<= (* 2 contra) examples)]
    (println (format "The sub rule %s is %s. There are %d examples and %d counter-examples.\n" desc (format-plausible plausible?) examples contra))
    plausible?))

(defn i-before-e-except-after-c-plausible?
  "Check if i before e after c plausible?"
  [description words]
  (do
    (println description)
    (let [counts (count-ie-ei-combinations words)
          subrule1 (apply-rule "I before E when not preceeded by C" (:ie counts) (:ei counts))
          subrule2 (apply-rule "E before I when preceeded by C" (:cei counts) (:cie counts))
          rule (and subrule1 subrule2)]
      (println (format "Overall the rule 'I before E except after C' is %s" (format-plausible rule)))
      rule)))

(defn format-freq-line [line] (letfn [(format-line [xs] [(first xs) (read-string (last xs))])]
                                       (-> line
                                           s/trim
                                           (s/split #"\s")
                                           format-line)))

(defn -main []
  (with-open [rdr (clojure.java.io/reader "http://www.puzzlers.org/pub/wordlists/unixdict.txt")]
   (i-before-e-except-after-c-plausible? "Check unixdist list" (apply-freq-1 (line-seq rdr))))
  (with-open [rdr (clojure.java.io/reader "http://ucrel.lancs.ac.uk/bncfreq/lists/1_2_all_freq.txt")]
   (i-before-e-except-after-c-plausible? "Word frequencies (stretch goal)" (map format-freq-line (drop 1 (line-seq rdr))))))
