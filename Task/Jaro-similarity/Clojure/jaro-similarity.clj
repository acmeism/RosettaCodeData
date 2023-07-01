(ns test-project-intellij.core
  (:gen-class))

(defn find-matches [s t]
  " find match locations in the two strings "
  " s_matches is set to true wherever there is a match in t and t_matches is set conversely "
  (let [s_len (count s)
        t_len (count t)
        match_distance (int (- (/ (max s_len t_len) 2) 1))
        matches 0
        transpositions 0
        fn-start (fn [i] (max 0 (- i match_distance)))              ; function to compute starting position
        fn-end (fn [i] (min (+ i match_distance 1) (- t_len 1))) ]  ; function to compute end position
    (loop [i 0
           start (fn-start i)
           end (fn-end i)
           k start
           s_matches (vec (repeat (count s) false))
           t_matches (vec (repeat (count t) false))
           matches 0]

      (if (< i s_len)

        (if (<= k end)

          (if (get t_matches k)
            ; continue with next k
            (recur i start end (inc k) s_matches t_matches matches)

            (if (= (get s i) (get t k))
              ; match a position, so update matches, s_matches, t_matches to reflect match
              (recur (inc i) (fn-start (inc i)) (fn-end (inc i)) (fn-start (inc i)) (assoc s_matches i true) (assoc t_matches k true) (inc matches))
              ; no match so try next k
              (recur i start end (inc k) s_matches t_matches matches)))

          ; End of k iterations, so increment i and set k to start based upon i
          (recur (inc i) (fn-start (inc i)) (fn-end (inc i)) (fn-start (inc i)) s_matches t_matches matches))

        ; End of i iterations
        [matches s_matches t_matches]))))

(defn count-transpositions [s t s_matches t_matches]
  " Utility function to count the number of transpositions "
  (let [s_len (count s)]
    (loop [i 0
           k 0
           transpositions 0]

      (if (< i s_len)
        ; still elements in s (since i < s_len)
        (if (not (get s_matches i nil))
          ; skip to next i since there are no matches in s
          (recur (inc i) k transpositions)
          ; checking for match in t
          (if (not (get t_matches k nil))
            ; keeping looping around as long as there are no matches in t
            (recur i (inc k) transpositions)
            (if (not= (get s i) (get t k))
              ; increment transposition count (if strings don't equal at match location)
              (recur (inc i) (inc k) (inc transpositions))
              ; was a match, so advance i and k without increasing transpositions count
              (recur (inc i) (inc k) transpositions))))
        ; Return count
        transpositions))))

(defn jaro [s t]
  " Main Jaro Distance routine"
  (if (= s t)
    1
    (let [[matches s_matches t_matches]  (find-matches s t)]
      (if (= 0 matches)
        0
        (let [s_len (count s)
              t_len (count t)
              transpositions (count-transpositions s t s_matches t_matches)]
          (float (/ (+ (/ matches s_len) (/ matches t_len) (/ (- matches (/ transpositions 2)) matches)) 3)))))))


(println (jaro "MARTHA" "MARHTA"))
(println (jaro "DIXON" "DICKSONX"))
(println (jaro "JELLYFISH" "SMELLYFISH"))
