(defn rosetta-compare [s1 s2]
  (let [len1 (count s1), len2 (count s2)]
    (if (= len1 len2)
      (compare (.toLowerCase s1) (.toLowerCase s2))
      (- len2 len1))))

(println
 (sort rosetta-compare
       ["Here" "are" "some" "sample" "strings" "to" "be" "sorted"]))
