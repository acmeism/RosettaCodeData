ns longest-string
  (:gen-class))

(defn longer [a b]
  " if a is longer, it returns the characters in a after length b characters have been removed
    otherwise it returns nil "
  (if (or (empty? a) (empty? b))
    (not-empty a)
    (recur (rest a) (rest b))))

(defn get-input []
  " Gets the data from standard input as a lazy-sequence of lines (i.e. reads lines as needed by caller
    Input is terminated by a zero length line (i.e. line with just <CR> "
  (let [line (read-line)]
    (if (> (count line) 0)
      (lazy-seq (cons line (get-input)))
      nil)))

(defn process []
  " Returns list of longest lines "
  (first                                                             ; takes lines from [lines longest]
    (reduce (fn [[lines longest] x]
             (cond
              (longer x longest) [x x]                               ; new longer line
              (not (longer longest x)) [(str lines "\n" x) longest] ; append x to previous longest
              :else [lines longest]))                               ; keep previous lines & longest
            ["" ""] (get-input))))

(println "Input text:")
(println "Output:\n" (process))
