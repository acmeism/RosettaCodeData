(ns tanevaulator
  (:gen-class))

;; Notation: [a b c] -> a x arctan(a/b)
(def test-cases   [
                          [[1, 1, 2], [1, 1, 3]],
                          [[2, 1, 3], [1, 1, 7]],
                          [[4, 1, 5], [-1, 1, 239]],
                          [[5, 1, 7], [2, 3, 79]],
                          [[1, 1, 2], [1, 1, 5], [1, 1, 8]],
                          [[4, 1, 5], [-1, 1, 70], [1, 1, 99]],
                          [[5, 1, 7], [4, 1, 53], [2, 1, 4443]],
                          [[6, 1, 8], [2, 1, 57], [1, 1, 239]],
                          [[8, 1, 10], [-1, 1, 239], [-4, 1, 515]],
                          [[12, 1, 18], [8, 1, 57], [-5, 1, 239]],
                          [[16, 1, 21], [3, 1, 239], [4, 3, 1042]],
                          [[22, 1, 28], [2, 1, 443], [-5, 1, 1393], [-10, 1, 11018]],
                          [[22, 1, 38], [17, 7, 601], [10, 7, 8149]],
                          [[44, 1, 57], [7, 1, 239], [-12, 1, 682], [24, 1, 12943]],
                          [[88, 1, 172], [51, 1, 239], [32, 1, 682], [44, 1, 5357], [68, 1, 12943]],
                          [[88, 1, 172], [51, 1, 239], [32, 1, 682], [44, 1, 5357], [68, 1, 12944]]
                  ])

(defn tan-sum [a b]
  " tan (a + b) "
  (/ (+ a b) (- 1 (* a b))))

(defn tan-eval [m]
  " Evaluates tan of a triplet (e.g. [1, 1, 2])"
  (let [coef (first m)
        rat (/ (nth m 1) (nth m 2))]
  (cond
    (= 1  coef) rat
    (neg? coef) (tan-eval [(- (nth m 0)) (- (nth m 1)) (nth m 2)])
    :else (let [
                ca (quot coef 2)
                cb (- coef ca)
                a (tan-eval [ca (nth m 1) (nth m 2)])
                b (tan-eval [cb (nth m 1) (nth m 2)])]
            (tan-sum a b)))))

(defn tans [m]
  " Evaluates tan of set of triplets (e.g. [[1, 1, 2], [1, 1, 3]])"
  (if (= 1 (count m))
    (tan-eval (nth m 0))
    (let [a (tan-eval (first m))
          b (tans (rest m))]
      (tan-sum a b))))

(doseq [q test-cases]
  " Display results "
  (println "tan " q " = "(tans q)))
