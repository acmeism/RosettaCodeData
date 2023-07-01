(defn pancake-sort
  [arr]
  (if (= 1 (count arr))
    arr
    (when-let [mx (apply max arr)]
      (let [tk    (split-with #(not= mx %) arr)
            tail  (second tk)
            torev (concat (first tk) (take 1 tail))
            head  (reverse torev)]
        (cons mx (pancake-sort (concat (drop 1 head) (drop 1 tail))))))))
