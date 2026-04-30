(defn check-all-same-characters
  [str]
  (printf "Input: \"%s\", length: %d." str (length str))
  (if-let [c (first str)
           i (find-index |(not= c $) str)]
    (printf "Character '%c' (0x%x) at index %d differs." (str i) (str i) i)
    (printf "All characters are the same.")))

(each str ["" "   " "2" "333" ".55" "tttTTT" "4444 444k"]
  (check-all-same-characters str))
