(ns clojure-sandbox.statenames
  (:require [clojure.data.csv :as csv]
            [clojure.java.io :as io]
            [clojure.string :refer [lower-case]]
            [clojure.math.combinatorics :as c]
            [clojure.pprint :as pprint]))

(def made-up-states ["New Kory" "Wen Kory" "York New" "Kory New" "New Kory"])

;; I saved the list of states in a local file to keep the code clean but you can copy and paste the list instead
(def real-states (with-open [in-file (io/reader (io/resource "states.csv"))]
                   (->> (doall
                         (csv/read-csv in-file))
                        (map first))))

(defn- state->charset [state-name]
  "Convert state name into sorted list of characters with no spaces"
  (->> state-name
       char-array
       sort
       (filter (set (map char (range 97 123)))))) ;; ASCII range for lower case letters

(defn- add-charsets [states]
  "Calculate sorted character list for each state and store with name"
  (->> states
       (map lower-case) ;; Convert all names to lower case
       set ;; remove duplicates
       (map
        (fn [s] {:name s
                 :characters (state->charset s)})))) ;; add characters

(defn- pair-chars [state1 state2]
  "Join the characters of two states together and sort them"
  (-> state1
      :characters
      (concat (:characters state2))
      sort))

(defn- pair [[state1 state2]]
  "Record representing two state names and the total characters used in them"
  {:inputs [(:name state1) (:name state2)]
   :characters (pair-chars state1 state2)})

(defn- find-all-pairs [elements]
  (c/combinations elements 2))

(defn- pairs-to-search [state-names]
  "Create character lists for all states and return a list of all possible pairs"
  (->> state-names
       add-charsets
       find-all-pairs
       (map pair)))

(defn- pairs-have-same-letters? [[pair1 pair2]]
  (= (:characters pair1) (:characters pair2)))

(defn- inputs-are-distinct? [[pair1 pair2 :as pairs]]
  "Check that two pairs of states don't contain the same state"
  (= 4 ;; There should be a total of 4 distinct states in the two pairs
     (->> pairs
          (map :inputs)
          flatten
          set
          count)))

(defn- search [pairs]
  (->> pairs
       find-all-pairs ;; find pairs of pairs to search
       (filter pairs-have-same-letters?) ;; Keep only those where each pair has the same characters
       (filter inputs-are-distinct?))) ;; Remove pairs with duplicate states

(defn find-matches [state-names]
  "Find all state pairs and return pairs of them using the same letters"
  (-> state-names
      pairs-to-search
      search))

(defn- format-match-output [[pair1 pair2]]
  "Format a pair of state pairs to print out"
  (str (first (:inputs pair1))
       " + "
       (last (:inputs pair1))
       " = "
       (first (:inputs pair2))
       " + "
       (last (:inputs pair2))))

(defn- evaluate-and-print [states]
  (->> states
       find-matches
       (map format-match-output)
       pprint/pprint))

(defn -main [& args]
  (println "Solutions for 50 real states")
  (evaluate-and-print real-states)
  (println "Solutions with made up states added")
  (evaluate-and-print (concat real-states made-up-states)))
