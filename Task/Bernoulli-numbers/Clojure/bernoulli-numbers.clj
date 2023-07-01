ns test-project-intellij.core
  (:gen-class))

(defn a-t [n]
  " Used Akiyama-Tanigawa algorithm with a single loop rather than double nested loop "
  " Clojure does fractional arithmetic automatically so that part is easy "
  (loop [m 0
         j m
         A (vec (map #(/ 1 %) (range 1 (+ n 2))))] ; Prefil A(m) with 1/(m+1), for m = 1 to n
    (cond                                          ; Three way conditional allows single loop
      (>= j 1) (recur m (dec j) (assoc A (dec j) (* j (- (nth A (dec j)) (nth A j))))) ; A[j-1] ← j×(A[j-1] - A[j]) ;
      (< m n) (recur (inc m) (inc m) A)                                                 ; increment m, reset j = m
      :else (nth A 0))))

(defn format-ans [ans]
  " Formats answer so that '/' is aligned for all answers "
  (if (= ans 1)
  (format "%50d / %8d" 1 1)
  (format "%50d / %8d" (numerator ans) (denominator ans))))

;; Generate a set of results for [0 1 2 4 ... 60]
(doseq [q (flatten [0 1 (range 2 62 2)])
        :let [ans (a-t q)]]
  (println q ":" (format-ans ans)))
