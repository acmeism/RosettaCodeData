(defn permutation-swaps
  "List of swap indexes to generate all permutations of n elements"
  [n]
  (if (= n 2) `((0 1))
    (let [old-swaps (permutation-swaps (dec n))
          swaps-> (partition 2 1 (range n))
          swaps<- (reverse swaps->)]
      (mapcat (fn [old-swap side]
                (case side
                  :first swaps<-
                  :right (conj swaps<- old-swap)
                  :left (conj swaps-> (map inc old-swap))))
              (conj old-swaps nil)
              (cons :first (cycle '(:left :right)))))))


(defn swap [v [i j]]
  (-> v
      (assoc i (nth v j))
      (assoc j (nth v i))))


(defn permutations [n]
  (let [permutations (reduce
                       (fn [all-perms new-swap]
                         (conj all-perms (swap (last all-perms)
                                               new-swap)))
                       (vector (vec (range n)))
                       (permutation-swaps n))
        output (map vector
                    permutations
                    (cycle '(1 -1)))]
    output))


(doseq [n [2 3 4]]
  (dorun (map println (permutations n))))
