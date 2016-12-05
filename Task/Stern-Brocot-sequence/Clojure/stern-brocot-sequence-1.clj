;; compute the Nth (1-based) Stern-Brocot number directly
(defn nth-stern-brocot [n]
  (if (< n 2)
    n
    (let [h (quot n 2) h1 (inc h) hth (nth-stern-brocot h)]
      (if (zero? (mod n 2)) hth (+ hth (nth-stern-brocot h1))))))

;; return a lazy version of the entire Stern-Brocot sequence
(defn stern-brocot
  ([] (stern-brocot 1))
  ([n] (cons (nth-stern-brocot n) (lazy-seq (stern-brocot (inc n))))))

(printf "Stern-Brocot numbers 1-15: %s%n"
        (clojure.string/join ", " (take 15 (stern-brocot))))

(dorun (for [n (concat (range 1 11) [100])]
  (printf "The first appearance of %3d is at index %4d.%n"
    n (inc (first (keep-indexed #(when (= %2 n) %1) (stern-brocot)))))))
