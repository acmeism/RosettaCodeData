{1 "a", "Q" 10} ; commas are treated as whitespace
(hash-map 1 "a" "Q" 10) ; equivalent to the above
(let [my-map {1 "a"}]
  (assoc my-map "Q" 10)) ; "adding" an element
