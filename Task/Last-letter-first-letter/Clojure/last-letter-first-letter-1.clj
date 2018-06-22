(ns rosetta-code.last-letter-first-letter
  (:require clojure.string))

(defn by-first-letter
  "Returns a map from letters to a set of words that start with that letter"
  [words]
  (into {} (map (fn [[k v]]
                  [k (set v)]))
        (group-by first words)))

(defn longest-path-from
  "Find a longest path starting at word, using only words-by-first-letter for successive words.
  Returns a pair of [length list-of-words] to describe the path."
  [word words-by-first-letter]
  (let [words-without-word (update words-by-first-letter (first word)
                                   disj word)
        next-words (words-without-word (last word))]
    (if (empty? next-words)
      [1 [word]]
      (let [sub-paths (map #(longest-path-from % words-without-word) next-words)
            [length words-of-path] (apply max-key first sub-paths)]
        [(inc length) (cons word words-of-path)]))))

(defn longest-word-chain
  "Find a longest path among the words in word-list, by performing a longest path search
  starting at each word in the list."
  [word-list]
  (let [words-by-letter (by-first-letter word-list)]
    (apply max-key first
           (pmap #(longest-path-from % words-by-letter)
                 word-list))))

(defn word-list-from-file [file-name]
  (let [contents (slurp file-name)
        words (clojure.string/split contents #"[ \n]")]
    (filter #(not (empty? %)) words)))

(time (longest-word-chain (word-list-from-file "pokemon.txt")))
