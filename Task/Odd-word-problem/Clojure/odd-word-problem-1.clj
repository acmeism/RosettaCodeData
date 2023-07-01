(defn next-char []
  (char (.read *in*)))

(defn forward []
  (let [ch (next-char)]
    (print ch)
    (if (Character/isLetter ch)
      (forward)
      (not= ch \.))))

(defn backward []
  (let [ch (next-char)]
    (if (Character/isLetter ch)
      (let [result (backward)]
        (print ch)
        result)
      (fn [] (print ch) (not= ch \.)))) )

(defn odd-word [s]
  (with-in-str s
    (loop [forward? true]
      (when (if forward?
              (forward)
              ((backward)))
        (recur (not forward?)))) )
    (println))
