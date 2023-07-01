(ns test-p.core)

(defn numbers-only [x]
  " Just shows the numbers only for the pairs (i.e. drops the direction --used for display purposes when printing the result"
  (mapv first x))

(defn next-permutation
  " Generates next permutation from the current (p) using the Johnson-Trotter technique
    The code below translates the Python version which has the following steps:
     p of form [...[n dir]...] such as [[0 1] [1 1] [2 -1]], where n is a number and dir = direction (=1=right, -1=left, 0=don't move)
     Step: 1 finds the pair [n dir] with the largest value of n (where dir is not equal to 0 (done if none)
     Step: 2: swap the max pair found with its neighbor in the direction of the pair (i.e. +1 means swap to right, -1 means swap left
     Step 3: if swapping places the pair a the beginning or end of the list, set the direction = 0 (i.e. becomes non-mobile)
     Step 4: Set the directions of all pairs whose numbers are greater to the right of where the pair was moved to -1 and to the left to +1 "
  [p]
  (if (every? zero? (map second p))
    nil                                                                 ; no mobile elements (all directions are zero)
    (let [n (count p)
          ; Step 1
          fn-find-max (fn [m]
                        (first (apply max-key                           ; find the max mobile elment
                                   (fn [[i x]]
                                     (if (zero? (second x))
                                       -1
                                       (first x)))
                                              (map-indexed vector p))))
          i1 (fn-find-max p)                                            ; index of max
          [n1 d1] (p i1)                                                ; value and direction of max
          i2 (+ d1 i1)
          fn-swap (fn [m] (assoc m i2 (m i1) i1 (m i2)))                ; function to swap with neighbor in our step direction
          fn-update-max (fn [m] (if (or (contains? #{0 (dec n)} i2)     ; update direction of max (where max went)
                                        (> ((m (+ i2 d1)) 0) n1))
                                  (assoc-in m [i2 1] 0)
                                  m))
          fn-update-others (fn [[i3 [n3 d3]]]                            ; Updates directions of pairs to the left and right of max
                             (cond                                       ; direction reset to -1 if to right, +1 if to left
                               (<= n3 n1) [n3 d3]
                               (< i3 i2) [n3 1]
                               :else      [n3 -1]))]
      ; apply steps 2, 3, 4(using functions that where created for these steps)
      (mapv fn-update-others (map-indexed vector (fn-update-max (fn-swap p)))))))

(defn spermutations
  " Lazy sequence of permutations of n digits"
  ; Each element is two element vector (number direction)
  ; Startup case - generates sequence 0...(n-1) with move direction (1 = move right, -1 = move left, 0 = don't move)
  ([n] (spermutations 1
                      (into [] (for [i (range n)] (if (zero? i)
                                                    [i 0]               ; 0th element is not mobile yet
                                                    [i -1])))))         ; all others move left
  ([sign p]
   (when-let [s (seq p)]
             (cons [(numbers-only p) sign]
                   (spermutations (- sign) (next-permutation p))))))   ; recursively tag onto sequence


;; Print results for 2, 3, and 4 items
(doseq [n (range 2 5)]
  (do
    (println)
    (println (format "Permutations and sign of %d items " n))
  (doseq [q (spermutations n)] (println (format "Perm: %s Sign: %2d" (first q) (second q))))))
