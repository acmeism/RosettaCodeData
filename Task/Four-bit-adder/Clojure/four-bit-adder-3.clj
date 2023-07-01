(defn to-binary-seq [^long x]
  (map #(- (int %) (int \0))
       (Long/toBinaryString x)))

(defn half-adder [a b]
  [(bit-xor a b)
   (bit-and a b)])

(defn full-adder [a b carry]
  (let [added (half-adder b carry)
        half-sum (first added)]
    [(first (half-adder a half-sum))
     (bit-or (second (half-adder a half-sum)) (second added))]))

(defn ripple-carry-adder [a b]
  (loop [a (reverse a)
         b (reverse b)
         sum '()
         carry 0]
    (let [added (full-adder (first a) (first b) carry)]
      (if (and (empty? (next a)) (empty? (next b)))
        (conj sum (first added) (bit-or carry 1))
        (recur (next a) (next b) (conj sum (first added)) (second added))))))

(deftest adder
  (is (= (Long/parseLong (apply str (ripple-carry-adder (to-binary-seq 10) (to-binary-seq 10))) 2)
         (+ 10 10)))
  (is (= (Long/parseLong (apply str (ripple-carry-adder (to-binary-seq 50) (to-binary-seq 50))) 2)
         (+ 50 50)))
  (is (= (Long/parseLong (apply str (ripple-carry-adder (to-binary-seq 32) (to-binary-seq 38))) 2)
         (+ 32 38)))
  (is (= (Long/parseLong (apply str (ripple-carry-adder (to-binary-seq 130) (to-binary-seq 250))) 2)
         (+ 130 250))))
