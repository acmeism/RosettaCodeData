(ns rosetta.fourbit)

;; a bit is represented as a boolean (true/false)
;; a word is a big-endian vector of bits [true false true true] = 11
;; multiple values are returned as vectors

(defn or-gate [a b]
  (or a b))

(defn and-gate [a b]
  (and a b))

(defn not-gate [a]
  (not a))

(defn xor-gate [a b]
  (or-gate (and-gate (not-gate a) b) (and-gate a (not-gate b))))

(defn half-adder [a b]
  "result is [carry sum]"
  (let [carry (and-gate a b)
        sum (xor-gate a b)]
    [carry sum]))

(defn full-adder [a b c0]
  "result is [carry sum]"
  (let [[ca sa] (half-adder c0 a)
        [cb sb] (half-adder sa b)]
    [(or-gate ca cb) sb]))

(defn nbit-adder [va vb]
  "va and vb should be big endian bit vectors of the same size. The result
is a bit vector having one more bit (carry) than args."
  {:pre [(= (count va) (count vb))]}
  (let [[c sums] (reduce (fn [[carry sums] [a b]]
                              (let [[c s] (full-adder a b carry)]
                                [c (conj sums s)]))
                         ;; initial value: false carry and an empty list of sums
                         [false ()]
                         ;; rseq is constant-time reverse for vectors
                         (map vector (rseq va) (rseq vb)))]
    (vec (conj sums c))))

(defn four-bit-adder [a4 a3 a2 a1 b4 b3 b2 b1]
  "Returns [carry s4 s3 s2 s1]"
  (nbit-adder [a4 a3 a2 a1] [b4 b3 b2 b1]))

(comment
(four-bit-adder false true true false  true false true true)
;; [true false false false true]
)
