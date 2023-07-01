(ns rosettacode.rot-13)

(let [a (int \a) m (int \m) A (int \A) M (int \M)
      n (int \n) z (int \z) N (int \N) Z (int \Z)]
  (defn rot-13 [^Character c]
    (char (let [i (int c)]
      (cond-> i
        (or (<= a i m) (<= A i M)) (+ 13)
        (or (<= n i z) (<= N i Z)) (- 13))))))

(apply str (map rot-13 "The Quick Brown Fox Jumped Over The Lazy Dog!"))

; An alternative implementation using a map:
(let [A (into #{} "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
      Am (->> (cycle A) (drop 26) (take 52) (zipmap A))]
  (defn rot13 [^String in]
    (apply str (map #(Am % %) in))))

(rot13 "The Quick Brown Fox Jumped Over The Lazy Dog!")
