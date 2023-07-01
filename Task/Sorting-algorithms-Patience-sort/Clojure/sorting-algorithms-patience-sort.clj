(defn patience-insert
  "Inserts a value into the sequence where each element is a stack.
   Comparison replaces the definition of less than.
   Uses the greedy strategy."
  [comparison sequence value]
  (lazy-seq
   (if (empty? sequence) `((~value)) ;; If there are no places to put the "card", make a new stack
       (let [stack (first sequence)
             top       (peek stack)]
         (if (comparison value top)
           (cons (conj stack value)  ;; Either put the card in a stack or recurse to the next stack
                 (rest sequence))
           (cons stack
                 (patience-insert comparison
                                  (rest sequence)
                                  value)))))))

(defn patience-remove
  "Removes the value from the top of the first stack it shows up in.
   Leaves the stacks otherwise intact."
  [sequence value]
  (lazy-seq
   (if (empty? sequence) nil              ;; If there are no stacks, we have no work to do
       (let [stack (first sequence)
             top       (peek stack)]
         (if (= top value)                ;; Are we there yet?
           (let [left-overs (pop stack)]
             (if (empty? left-overs)      ;; Handle the case that the stack is empty and needs to be removed
               (rest sequence)
               (cons left-overs
                     (rest sequence))))
           (cons stack
                 (patience-remove (rest sequence)
                                  value)))))))

(defn patience-recover
  "Builds a sorted sequence from a list of patience stacks.
   The given comparison takes the place of 'less than'"
  [comparison sequence]
  (loop [sequence sequence
         sorted         []]
    (if (empty? sequence) sorted
        (let [smallest  (reduce #(if (comparison %1 %2) %1 %2)  ;; Gets the smallest element in the list
                                (map peek sequence))
              remaining    (patience-remove sequence smallest)]
          (recur remaining
                 (conj sorted smallest)))))) ;; Recurse over the remaining values and add the new smallest to the end of the sorted list

(defn patience-sort
  "Sorts the sequence by comparison.
   First builds the list of valid patience stacks.
   Then recovers the sorted list from those.
   If you don't supply a comparison, assumes less than."
  ([comparison sequence]
     (->> (reduce (comp doall ;; This is prevent a stack overflow by making sure all work is done when it needs to be
                        (partial patience-insert comparison)) ;; Insert all the values into the list of stacks
                  nil
                  sequence)
          (patience-recover comparison)))              ;; After we have the stacks, send it off to recover the sorted list
  ([sequence]
     ;; In the case we don't have an operator, defer to ourselves with less than
     (patience-sort < sequence)))

;; Sort the test sequence and print it
(println (patience-sort [4 65 2 -31 0 99 83 782 1]))
