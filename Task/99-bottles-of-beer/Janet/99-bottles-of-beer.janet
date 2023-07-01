(defn bottles [n]
  (match n
    0 "No more bottles"
    1 "1 bottle"
    _ (string n " bottles")))

(loop [i :down [99 0]]
  (print
    (bottles i) " of beer on the wall\n"
    (bottles i) " of beer\nTake one down, pass it around\n"
    (bottles (- i 1)) " of beer on the wall\n\n"))
