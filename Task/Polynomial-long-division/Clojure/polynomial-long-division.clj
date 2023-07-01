(defn grevlex [term1 term2]
  (let [grade1 (reduce +' term1)
        grade2 (reduce +' term2)
        comp (- grade2 grade1)] ;; total degree
    (if (not= 0 comp)
      comp
      (loop [term1 term1
             term2 term2]
        (if (empty? term1)
          0
          (let [grade1 (last term1)
                grade2 (last term2)
                comp (- grade1 grade2)] ;; differs from grlex because terms are flipped from above
            (if (not= 0 comp)
            comp
            (recur (pop term1)
                   (pop term2)))))))))

(defn mul
  ;; transducer
  ([poly1]  ;; completion
   (fn
     ([] poly1)
     ([poly2] (mul poly1 poly2))
     ([poly2 & more] (mul poly1 poly2 more))))
  ([poly1 poly2]
   (let [product (atom (transient (sorted-map-by grevlex)))]
     (doall  ;; `for` is lazy so must to be forced for side-effects
      (for [term1 poly1
            term2 poly2
            :let [vars (mapv +' (key term1) (key term2))
                  coeff (* (val term1) (val term2))]]
        (if (contains? @product vars)
          (swap! product assoc! vars (+ (get @product vars) coeff))
          (swap! product assoc! vars coeff))))
     (->> product
          (deref)
          (persistent!)
          (denull))))
  ([poly1 poly2 & more]
   (reduce mul (mul poly1 poly2) more)))

(defn compl [term1 term2]
  (map (fn [x y]
         (cond
           (and (zero? x) (not= 0 y)) nil
           (< x y) nil
           (>= x y) (- x y)))
       term1
       term2))

(defn s-poly [f g]
  (let [f-vars (first f)
        g-vars (first g)
        lcm (compl f-vars g-vars)]
    (if (not-any? nil? lcm)
      {(vec lcm)
       (/ (second f) (second g))})))

(defn divide [f g]
  (loop [f f
         g g
         result (transient {})
         remainder {}]
    (if (empty? f)
      (list (persistent! result)
            (->> remainder
                 (filter #(not (nil? %)))
                 (into (sorted-map-by grevlex))))
      (let [term1 (first f)
            term2 (first g)
            s-term (s-poly term1 term2)]
        (if (nil? s-term)
          (recur (dissoc f (first term1))
                 (dissoc g (first term2))
                 result
                 (conj remainder term1))
          (recur (sub f (mul g s-term))
                 g
                 (conj! result s-term)
                 remainder))))))

(deftest divide-tests
  (is (= (divide {[1 1] 2, [1 0] 3, [0 1] 5, [0 0] 7}
                 {[1 1] 2, [1 0] 3, [0 1] 5, [0 0] 7})
         '({[0 0] 1} {})))
  (is (= (divide {[1 1] 2, [1 0] 3, [0 1] 5, [0 0] 7}
                 {[0 0] 1})
         '({[1 1] 2, [1 0] 3, [0 1] 5, [0 0] 7} {})))
  (is (= (divide {[1 1] 2, [1 0] 10, [0 1] 3, [0 0] 15}
                 {[0 1] 1, [0 0] 5})
         '({[1 0] 2, [0 0] 3} {})))
  (is (= (divide {[1 1] 2, [1 0] 10, [0 1] 3, [0 0] 15}
                 {[1 0] 2, [0 0] 3})
         '({[0 1] 1, [0 0] 5} {}))))
