(defn pad-class
  [n]
  (let [divs (filter #(zero? (mod n %)) (range 1 n))
        divs-sum (reduce + divs)]
    (cond
      (< divs-sum n) :deficient
      (= divs-sum n) :perfect
      (> divs-sum n) :abundant)))

(def pad-classes (map pad-class (map inc (range))))

(defn count-classes
  [n]
  (let [classes (take n pad-classes)]
    {:perfect (count (filter #(= % :perfect) classes))
     :abundant (count (filter #(= % :abundant) classes))
     :deficient (count (filter #(= % :deficient) classes))}))
