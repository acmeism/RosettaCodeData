(defn diversity-theorem [truth predictions]
  (let [square (fn[x] (* x x))
        mean (/ (reduce + predictions) (count predictions))
        avg-sq-diff (fn[a] (/ (reduce + (for [x predictions] (square (- x a)))) (count predictions)))]
    {:average-error (avg-sq-diff truth)
     :crowd-error (square (- truth mean))
     :diversity (avg-sq-diff mean)}))

(println (diversity-theorem 49 '(48 47 51)))
(println (diversity-theorem 49 '(48 47 51 42)))
